local Library = require "CoronaLibrary"

local lib

-- Create stub library for simulator
lib = Library:new{ name='plugin.adSense', publisherId='com.solar2d' }
-- Default implementations
local function defaultFunction()
	print( "WARNING: The '" .. lib.name .. "' library is not available on this platform." )
	return 0
end

lib.init = defaultFunction
lib.show = defaultFunction
lib.hide = defaultFunction
lib.height = defaultFunction


-- Return an instance
return lib
