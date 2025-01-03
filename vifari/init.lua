local obj = {}
obj.__index = obj

--------------------------------------------------------------------------------
--- metadata
--------------------------------------------------------------------------------

obj.name = "vifari"
obj.version = "0.0.2"
obj.author = "Sergey Tarasov <dzirtusss@gmail.com>"
obj.homepage = "https://github.com/dzirtusss/vifari"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--------------------------------------------------------------------------------
--- config
--------------------------------------------------------------------------------

local mapping = {
  ["i"] = "cmdInsertMode",
  ["n"] = "cmdNext",
  ["N"] = "cmdPrevious",
  -- movements
  -- ["h"] = "cmdScrollLeft",
  ["j"] = "cmdScrollDown",
  ["k"] = "cmdScrollUp",
  -- ["l"] = "cmdScrollRight",
  ["d"] = "cmdScrollHalfPageDown",
  ["u"] = "cmdScrollHalfPageUp",
  ["gg"] = { "cmd", "up" },
  ["G"] = { "cmd", "down" },
  -- tabs
  ["h"] = { { "cmd", "shift" }, "[" }, -- tab left
  ["l"] = { { "cmd", "shift" }, "]" }, -- tab right
  ["r"] = { "ctrl", "r" },              -- reload tab
  ["x"] = { "ctrl", "w" },              -- close tab
  ["t"] = { "ctrl", "t" },              -- new tab
  ["o"] = { "ctrl", "d" },              -- open
  ["H"] = { "cmd", "[" },              -- history back
  ["L"] = { "cmd", "]" },              -- history forward
  -- ["g1"] = { "cmd", "1" },
  -- ["g2"] = { "cmd", "2" },
  -- ["g3"] = { "cmd", "3" },
  -- ["g4"] = { "cmd", "4" },
  -- ["g5"] = { "cmd", "5" },
  -- ["g6"] = { "cmd", "6" },
  -- ["g7"] = { "cmd", "7" },
  -- ["g8"] = { "cmd", "8" },
  -- ["g9"] = { "cmd", "9" }, -- last tab
  -- ["g$"] = { "cmd", "9" }, -- last tab
  -- links
  ["f"] = "cmdGotoLink",
  ["F"] = "cmdGoToLinkInNewTabWithFocus",
  ["e"] = "cmdGoToLinkInNewTab",
  -- ["gf"] = "cmdMoveMouseToLink",
  -- mouse
  -- ["zz"] = "cmdMoveMouseToCenter",
  -- clipboard
  -- ["yy"] = "cmdCopyPageUrlToClipboard",
  -- ["yf"] = "cmdCopyLinkUrlToClipboard",
}

local config = {
  doublePressDelay = 0.3, -- seconds
  showLogs = false,
  mapping = mapping,
  scrollStep = 100,
  scrollStepHalfPage = 500,
  smoothScroll = false,
  smoothScrollHalfPage = true,
  axEditableRoles = { "AXTextField", "AXComboBox", "AXTextArea" },
  axJumpableRoles = { "AXLink", "AXButton", "AXPopUpButton", "AXComboBox", "AXTextField", "AXMenuItem", "AXTextArea" },
  nextKeywords = { "Next", "next", ">", ">>" },
  previousKeywords = { "Previous", "previous", "<", "<<" },
}

--------------------------------------------------------------------------------
-- helpers
--------------------------------------------------------------------------------

local cached = {}
local current = {}
local marks = { data = {} }
local menuBar = {}
local commands = {}
local safariFilter
local eventLoop
local modes = { DISABLED = 1, NORMAL = 2, INSERT = 3, MULTI = 4, LINKS = 5 }
local linkCapture
local lastEscape = hs.timer.absoluteTime()
local mappingPrefixes
local allCombinations

local function logWithTimestamp(message)
  if not config.showLogs then return end

  local timestamp = os.date("%Y-%m-%d %H:%M:%S")    -- Get current date and time
  local ms = math.floor(hs.timer.absoluteTime() / 1e6) % 1000
  hs.printf("[%s.%03d] %s", timestamp, ms, message) -- Print the message with the timestamp
end

local function tblContains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then return true end
  end
  return false
end

function current.app()
  cached.app = cached.app or hs.application.get("Safari")
  return cached.app
end

function current.axApp()
  cached.axApp = cached.axApp or hs.axuielement.applicationElement(current.app())
  return cached.axApp
end

function current.window()
  cached.window = cached.window or current.app():mainWindow()
  return cached.window
end

function current.axWindow()
  cached.axWindow = cached.axWindow or hs.axuielement.windowElement(current.window())
  return cached.axWindow
end

function current.axFocusedElement()
  cached.axFocusedElement = cached.axFocusedElement or current.axApp():attributeValue("AXFocusedUIElement")
  return cached.axFocusedElement
end

local function findAXRole(rootElement, role)
  if rootElement:attributeValue("AXRole") == role then return rootElement end

  for _, child in ipairs(rootElement:attributeValue("AXChildren") or {}) do
    local result = findAXRole(child, role)
    if result then return result end
  end
end

function current.axScrollArea()
  cached.axScrollArea = cached.axScrollArea or findAXRole(current.axWindow(), "AXScrollArea")
  return cached.axScrollArea
end

-- webarea path from window: AXWindow>AXSplitGroup>AXTabGroup>AXGroup>AXGroup>AXScrollArea>AXWebArea
function current.axWebArea()
  cached.axWebArea = cached.axWebArea or findAXRole(current.axWindow(), "AXWebArea")
  return cached.axWebArea
end

function current.visibleArea()
  if cached.visibleArea then return cached.visibleArea end

  local winFrame = current.axWindow():attributeValue("AXFrame")
  local scrollFrame = current.axScrollArea():attributeValue("AXFrame")
  local webFrame = current.axWebArea():attributeValue("AXFrame")

  -- TODO: sometimes it overlaps on scrollbars, need fixing logic on wide pages
  -- TDDO: doesn't work in fullscreen mode as well

  local visibleX = math.max(winFrame.x, webFrame.x)
  local visibleY = math.max(winFrame.y, scrollFrame.y)

  local visibleWidth = math.min(winFrame.x + winFrame.w, webFrame.x + webFrame.w) - visibleX
  local visibleHeight = math.min(winFrame.y + winFrame.h, webFrame.y + webFrame.h) - visibleY

  cached.visibleArea = {
    x = visibleX,
    y = visibleY,
    w = visibleWidth,
    h = visibleHeight
  }

  return cached.visibleArea
end

local function isEditableControlInFocus()
  if current.axFocusedElement() then
    return tblContains(config.axEditableRoles, current.axFocusedElement():attributeValue("AXRole"))
  else
    return false
  end
end

local function isSpotlightActive()
  local app = hs.application.get("Spotlight")
  local appElement = hs.axuielement.applicationElement(app)
  local windows = appElement:attributeValue("AXWindows")
  return #windows > 0
end

-- TODO: do some better logic here
local function generateCombinations()
  local chars = "dfghjklweruio"
  -- local chars = "abcdefghijklmnopqrstuvwxyz"
  allCombinations = {}
  for i = 1, #chars do
    for j = 1, #chars do
      table.insert(allCombinations, chars:sub(i, i) .. chars:sub(j, j))
    end
  end
end

local function smoothScroll(x, y, smooth)
  if smooth then
    local xstep = x / 5
    local ystep = y / 5
    hs.eventtap.event.newScrollEvent({ xstep, ystep }, {}, "pixel"):post()
    hs.timer.doAfter(0.01, function() hs.eventtap.event.newScrollEvent({ xstep * 3, ystep * 3 }, {}, "pixel"):post() end)
    hs.timer.doAfter(0.01, function() hs.eventtap.event.newScrollEvent({ xstep, ystep }, {}, "pixel"):post() end)
  else
    hs.eventtap.event.newScrollEvent({ x, y }, {}, "pixel"):post()
  end
end

local function openUrlWithNewTab(url)
  local script = [[
      tell application "Safari"
        activate
        tell window 1
          make new tab with properties {URL:"%s"}
        end tell
      end tell
    ]]
  script = string.format(script, url)
  hs.osascript.applescript(script)
end

local function openUrlWithNewTabInFocus(url)
  local script = [[
      tell application "Safari"
        activate
        tell window 1
          set current tab to (make new tab with properties {URL:"%s"})
        end tell
      end tell
    ]]
  script = string.format(script, url)
  hs.osascript.applescript(script)
end

local function setClipboardContents(contents)
  if contents and hs.pasteboard.setContents(contents) then
    hs.alert.show("Copied to clipboard: " .. contents, nil, nil, 4)
  else
    hs.alert.show("Failed to copy to clipboard", nil, nil, 4)
  end
end

local function forceUnfocus()
  logWithTimestamp("forced unfocus on escape")
  if current.axWebArea() then
    current.axWebArea():setAttributeValue("AXFocused", true)
  end
end

--------------------------------------------------------------------------------
-- menubar
--------------------------------------------------------------------------------

function menuBar.new()
  if menuBar.item then menuBar.delete() end
  menuBar.item = hs.menubar.new()
end

function menuBar.delete()
  if menuBar.item then menuBar.item:delete() end
  menuBar.item = nil
end

local function setMode(mode, char)
  local defaultModeChars = {
    [modes.DISABLED] = "X",
    [modes.NORMAL] = "V",
  }

  local previousMode = current.mode
  current.mode = mode

  if current.mode == modes.LINKS and previousMode ~= modes.LINKS then
    linkCapture = ""
    marks.clear()
  end
  if previousMode == modes.LINKS and current.mode ~= modes.LINKS then
    linkCapture = nil
    hs.timer.doAfter(0, marks.clear)
  end

  if current.mode == modes.MULTI then current.multi = char end
  if current.mode ~= modes.MULTI then current.multi = nil end

  menuBar.item:setTitle(char or defaultModeChars[mode] or "?")
end

--------------------------------------------------------------------------------
-- marks
--------------------------------------------------------------------------------

function marks.clear()
  if marks.canvas then marks.canvas:delete() end
  marks.canvas = nil
  marks.data = {}
end

function marks.drawOne(markIndex)
  local mark = marks.data[markIndex]
  local visibleArea = current.visibleArea()
  local canvas = marks.canvas

  if not mark then return end
  if not marks.canvas then return end

  mark.position = mark.element:attributeValue("AXFrame")

  local padding = 2
  local fontSize = 14
  local bgRect = hs.geometry.rect(
    mark.position.x,
    mark.position.y,
    fontSize * 1.5 + 2 * padding,
    fontSize + 2 * padding
  )

  local fillColor
  if mark.element:attributeValue("AXRole") == "AXLink" then
    fillColor = { ["red"] = 1, ["green"] = 1, ["blue"] = 0, ["alpha"] = 1 }
  else
    fillColor = { ["red"] = 0.5, ["green"] = 1, ["blue"] = 0, ["alpha"] = 1 }
  end

  canvas:appendElements({
    type = "rectangle",
    fillColor = fillColor,
    strokeColor = { ["red"] = 0, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 },
    strokeWidth = 1,
    roundedRectRadii = { xRadius = 3, yRadius = 3 },
    frame = { x = bgRect.x - visibleArea.x, y = bgRect.y - visibleArea.y, w = bgRect.w, h = bgRect.h }
  })

  canvas:appendElements({
    type = "text",
    text = allCombinations[markIndex],
    textAlignment = "center",
    textColor = { ["red"] = 0, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 },
    textSize = fontSize,
    padding = padding,
    frame = { x = bgRect.x - visibleArea.x, y = bgRect.y - visibleArea.y, w = bgRect.w, h = bgRect.h }
  })
end

function marks.draw()
  marks.canvas = hs.canvas.new(current.visibleArea())

  -- area testing
  -- marksCanvas:appendElements({
  --   type = "rectangle",
  --   fillColor = { ["red"] = 0, ["green"] = 1, ["blue"] = 0, ["alpha"] = 0.1 },
  --   strokeColor = { ["red"] = 1, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 },
  --   strokeWidth = 2,
  --   frame = { x = 0, y = 0, w = visibleArea.w, h = visibleArea.h }
  -- })

  for i, _ in ipairs(marks.data) do
    marks.drawOne(i)
  end

  -- marksCanvas:bringToFront(true)
  marks.canvas:show()
end

function marks.add(element)
  table.insert(marks.data, { element = element })
end

function marks.isElementPartiallyVisible(element)
  if element:attributeValue("AXHidden") then return false end

  local frame = element:attributeValue("AXFrame")
  if not frame then return false end

  local visibleArea = current.visibleArea()

  local xOverlap = (frame.x < visibleArea.x + visibleArea.w) and (frame.x + frame.w > visibleArea.x)
  local yOverlap = (frame.y < visibleArea.y + visibleArea.h) and (frame.y + frame.h > visibleArea.y)

  return xOverlap and yOverlap
end

function marks.findClickableElements(element, withUrls)
  if not element then return end

  local jumpable = tblContains(config.axJumpableRoles, element:attributeValue("AXRole"))
  local visible = marks.isElementPartiallyVisible(element)
  local showable = not withUrls or element:attributeValue("AXURL")

  if jumpable and visible and showable then marks.add(element) end

  local children = element:attributeValue("AXChildren")
  if children then
    for _, child in ipairs(children) do
      marks.findClickableElements(child, withUrls)
    end
  end
end

function marks.show(withUrls)
  marks.findClickableElements(current.axWebArea(), withUrls)
  marks.draw()
end

function marks.click(combination)
  logWithTimestamp("marks.click")
  for i, c in ipairs(allCombinations) do
    if c == combination and marks.data[i] and marks.onClickCallback then
      marks.onClickCallback(marks.data[i])
    end
  end
end

function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function findButton(element, targetKeywords)
  if not element then return nil end

  local jumpable = tblContains(config.axJumpableRoles, element:attributeValue("AXRole"))
  local showable = element:attributeValue("AXURL")
  local linkText = element:attributeValue("AXTitle") or element:attributeValue("AXValue")

  if jumpable and showable and contains(targetKeywords, linkText) then
    return element
  end

  local children = element:attributeValue("AXChildren")
  if children then
    for _, child in ipairs(children) do
      local next_button = findButton(child, targetKeywords)
      if next_button ~= nil then
        return next_button
      end
    end
  end
  return nil
end

--------------------------------------------------------------------------------
-- commands
--------------------------------------------------------------------------------

function commands.cmdScrollLeft()
  smoothScroll(config.scrollStep, 0, config.smoothScroll)
end

function commands.cmdScrollRight()
  smoothScroll(-config.scrollStep, 0, config.smoothScroll)
end

function commands.cmdScrollUp()
  smoothScroll(0, config.scrollStep, config.smoothScroll)
end

function commands.cmdScrollDown()
  smoothScroll(0, -config.scrollStep, config.smoothScroll)
end

function commands.cmdScrollHalfPageDown()
  smoothScroll(0, -config.scrollStepHalfPage, config.smoothScrollHalfPage)
end

function commands.cmdScrollHalfPageUp()
  smoothScroll(0, config.scrollStepHalfPage, config.smoothScrollHalfPage)
end

function commands.cmdCopyPageUrlToClipboard()
  local axURL = current.axWebArea():attributeValue("AXURL")
  setClipboardContents(axURL.url)
end

function commands.cmdInsertMode(char)
  setMode(modes.INSERT, char)
end

function commands.cmdNext(char)
  local nextButton = findButton(current.axWebArea(), config.nextKeywords)
  if nextButton ~= nil then
    nextButton:performAction("AXPress")
  end
end

function commands.cmdPrevious(char)
  local previousButton = findButton(current.axWebArea(), config.previousKeywords)
  if previousButton ~= nil then
    previousButton:performAction("AXPress")
  end
end

function commands.cmdGotoLink(char)
  setMode(modes.LINKS, char)
  marks.onClickCallback = function(mark)
    mark.element:performAction("AXPress")
  end
  hs.timer.doAfter(0, marks.show)
end

function commands.cmdGoToLinkInNewTabWithFocus(char)
  setMode(modes.LINKS, char)
  marks.onClickCallback = function(mark)
    local axURL = mark.element:attributeValue("AXURL")
    openUrlWithNewTabInFocus(axURL.url)
  end
  hs.timer.doAfter(0, function() marks.show(true) end)
end

function commands.cmdGoToLinkInNewTab(char)
  setMode(modes.LINKS, char)
  marks.onClickCallback = function(mark)
    local axURL = mark.element:attributeValue("AXURL")
    openUrlWithNewTab(axURL.url)
  end
  hs.timer.doAfter(0, function() marks.show(true) end)
end

function commands.cmdMoveMouseToLink(char)
  setMode(modes.LINKS, char)
  marks.onClickCallback = function(mark)
    local frame = mark.element:attributeValue("AXFrame")
    hs.mouse.absolutePosition({ x = frame.x + frame.w / 2, y = frame.y + frame.h / 2 })
  end
  hs.timer.doAfter(0, marks.show)
end

function commands.cmdMoveMouseToCenter()
  hs.mouse.absolutePosition({
    x = current.visibleArea().x + current.visibleArea().w / 2,
    y = current.visibleArea().y + current.visibleArea().h / 2
  })
end

function commands.cmdCopyLinkUrlToClipboard(char)
  setMode(modes.LINKS, char)
  marks.onClickCallback = function(mark)
    local axURL = mark.element:attributeValue("AXURL")
    setClipboardContents(axURL.url)
  end
  hs.timer.doAfter(0, function() marks.show(true) end)
end

--------------------------------------------------------------------------------
--- vifari
--------------------------------------------------------------------------------

local function fetchMappingPrefixes()
  mappingPrefixes = {}
  for k, _ in pairs(config.mapping) do
    if #k == 2 then
      mappingPrefixes[string.sub(k, 1, 1)] = true
    end
  end
  logWithTimestamp("mappingPrefixes: " .. hs.inspect(mappingPrefixes))
end

local function vimLoop(char)
  logWithTimestamp("vimLoop " .. char)

  if current.mode == modes.LINKS then
    linkCapture = linkCapture .. char:lower()
    if #linkCapture == 2 then
      marks.click(linkCapture)
      setMode(modes.NORMAL)
    end
    return
  end

  if current.mode == modes.MULTI then char = current.multi .. char end
  local foundMapping = config.mapping[char]

  if foundMapping then
    setMode(modes.NORMAL)

    if type(foundMapping) == "string" then
      commands[foundMapping](char)
    elseif type(foundMapping) == "table" then
      hs.eventtap.keyStroke(foundMapping[1], foundMapping[2], 0)
    else
      logWithTimestamp("Unknown mapping for " .. char .. " " .. hs.inspect(foundMapping))
    end
  elseif mappingPrefixes[char] then
    logWithTimestamp("setting mode " .. modes.MULTI .. " " .. char)
    setMode(modes.MULTI, char)
  else
    logWithTimestamp("Unknown char " .. char)
  end
end

local function eventHandler(event)
  cached = {}

  for key, modifier in pairs(event:getFlags()) do
    if modifier and key ~= "shift" then return false end
  end

  if isSpotlightActive() then return false end

  if event:getKeyCode() == hs.keycodes.map["escape"] then
    local delaySinceLastEscape = (hs.timer.absoluteTime() - lastEscape) / 1e9 -- nanoseconds in seconds
    lastEscape = hs.timer.absoluteTime()

    if delaySinceLastEscape < config.doublePressDelay then
      setMode(modes.NORMAL)
      forceUnfocus()
      return true
    end

    if current.mode ~= modes.NORMAL then
      setMode(modes.NORMAL)
      return true
    end

    return false
  end

  if current.mode == modes.INSERT or isEditableControlInFocus() then return false end

  local char = event:getCharacters()
  if not char:match("[%a%d%[%]%$]") then return false end

  hs.timer.doAfter(0, function() vimLoop(char) end)
  return true
end

local function onWindowFocused()
  logWithTimestamp("onWindowFocused")
  if not eventLoop then
    eventLoop = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, eventHandler):start()
  end
  setMode(modes.NORMAL)
end

local function onWindowUnfocused()
  logWithTimestamp("onWindowUnfocused")
  if eventLoop then
    eventLoop:stop()
    eventLoop = nil
  end
  setMode(modes.DISABLED)
end

function obj:start()
  safariFilter = hs.window.filter.new("Safari")
  safariFilter:subscribe(hs.window.filter.windowFocused, onWindowFocused)
  safariFilter:subscribe(hs.window.filter.windowUnfocused, onWindowUnfocused)
  menuBar.new()
  fetchMappingPrefixes()
  generateCombinations()
end

function obj:stop()
  if safariFilter then
    safariFilter:unsubscribe(onWindowFocused)
    safariFilter:unsubscribe(onWindowUnfocused)
    safariFilter = nil
  end
  menuBar.delete()
end

return obj
