local adSense = require "adSense"
local json = require( "json" )
adSense.init(function (event)
  print(json.encode( event ))
  if(event.phase == "init" and event.isError == false)then
    adSense.show("banner",{adSlot="xxxxxxxx", height=150, position="bottom"})
    print(adSense.height())
  end
end, {clientId="ca-pub-xxxxxxxxxxx", testMode = true})

local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor(.5)

--this is sample I got from corona sample code
local arguments =
{
{ x=100, y=60, w=100, h=100, r=10, red=1, green=0, blue=0 },
{ x=60, y=100, w=100, h=100, r=10, red=0, green=1, blue=0 },
{ x=140, y=140, w=100, h=100, r=10, red=0, green=0, blue=1 }
}

local function getFormattedPressure( pressure )
if pressure then
return math.floor( pressure * 1000 + 0.5 ) / 1000
end
return "unsupported"
end

local function printTouch( event )
if event.target then
local bounds = event.target.contentBounds
end
end

local function onTouch( event )
local t = event.target

-- Print info about the event. For actual production code, you should
-- not call this function because it wastes CPU resources.
printTouch(event)

local phase = event.phase
if "began" == phase then
-- Make target the top-most object
local parent = t.parent
parent:insert( t )
display.getCurrentStage():setFocus( t )

-- Spurious events can be sent to the target, e.g. the user presses
-- elsewhere on the screen and then moves the finger over the target.
-- To prevent this, we add this flag. Only when it's true will "move"
-- events be sent to the target.
t.isFocus = true

-- Store initial position
t.x0 = event.x - t.x
t.y0 = event.y - t.y
elseif t.isFocus then
if "moved" == phase then
-- Make object move (we subtract t.x0,t.y0 so that moves are
-- relative to initial grab point, rather than object "snapping").
t.x = event.x - t.x0
t.y = event.y - t.y0

-- Gradually show the shape's stroke depending on how much pressure is applied.
if ( event.pressure ) then
t:setStrokeColor( 1, 1, 1, event.pressure )
end
elseif "ended" == phase or "cancelled" == phase then
display.getCurrentStage():setFocus( nil )
t:setStrokeColor( 1, 1, 1, 0 )
t.isFocus = false
end
end

-- Important to return true. This tells the system that the event
-- should not be propagated to listeners of any objects underneath.
return true
end

-- Iterate through arguments array and create rounded rects (vector objects) for each item
for _,item in ipairs( arguments ) do
local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
button:setFillColor( item.red, item.green, item.blue )
button.strokeWidth = 6
button:setStrokeColor( 1, 1, 1, 0 )

-- Make the button instance respond to touch events
button:addEventListener( "touch", onTouch )
end

-- listener used by Runtime object. This gets called if no other display object
-- intercepts the event.
local function printTouch2( event )
end

Runtime:addEventListener( "touch", printTouch2 )
