local quitModal = hs.hotkey.modal.new('cmd', 'q')

function quitModal:entered()
  hs.alert.show("Press Cmd+Q again to quit", 1)
  hs.timer.doAfter(1, function() quitModal:exit() end)
end

local function killApp()
  hs.application.frontmostApplication():kill()
  quitModal:exit()
end

quitModal:bind('cmd', 'q', killApp)
quitModal:bind('', 'escape', function() quitModal:exit() end)

local simpleCmd = false
local map = hs.keycodes.map
local function eikanaEvent(event)
  local c = event:getKeyCode()
  local f = event:getFlags()
  if event:getType() == hs.eventtap.event.types.keyDown then
    if f['cmd'] then
      simpleCmd = true
    end
  elseif event:getType() == hs.eventtap.event.types.flagsChanged then
    if not f['cmd'] then
      if simpleCmd == false then
        if c == map['cmd'] then
          hs.keycodes.setMethod('Alphanumeric (Google)')
        elseif c == map['rightcmd'] then
          hs.keycodes.setMethod('Hiragana (Google)')
        end
      end
      simpleCmd = false
    end
  end
end

eikana = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged}, eikanaEvent)
eikana:start()
