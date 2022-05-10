local lib

local platform = system.getInfo("platform")

if platform == 'html5' then
  lib = require("plugin_adSense_js")

  lib.size(display.actualContentWidth, display.actualContentHeight)
  --Incase config.lua is dynamic
  local function onResize( event )
      lib.size(display.actualContentWidth, display.actualContentHeight)
  end
  Runtime:addEventListener( "resize", onResize )
else
	-- wrapper for non web platforms
	local CoronaLibrary = require "CoronaLibrary"
	-- Create stub library for simulator
	lib = CoronaLibrary:new{ name='plugin.adSense', publisherId='com.solar2d' }
  -- Alert for non-HTML5 platforms
	local function defaultFunction()
		print( "WARNING: The '" .. lib.name .. "' library is not available on this platform." )
    return 0
  end

  lib.init = defaultFunction
  lib.show = defaultFunction
  lib.hide = defaultFunction
  lib.height = defaultFunction

end
return lib
