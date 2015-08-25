local wibox = require("wibox")
local theme = require("beautiful")
local capi = { screen = screen }
local naughty = naughty


module("test")

function create_testbox(width, height, x, y, bg_color, fg_color)
   local wbox = wibox({height = height, width = width, bg = bg_color, fg= fg_color})

   wbox.ontop = true
   wbox.visible = true
   
   naughty.notify({text='my wibox created ! with bg = ' .. bg_color});
   reposition_wibox(wbox, {x = x, y = y, width = width, height = height})  

   return wbox
end

function reposition_wibox(wbox, args)
   if not args then
      args = wiboxes[wbox]
   end

   local scr = args.screen or 1
   local scrgeom = capi.screen[scr].geometry --workarea
   local width = wbox.width
   local height = wbox.height
   local x = args.x or 0
   local y = args.y or 0

   if x >= 0 then
      x = scrgeom.x + x
   else
      x = scrgeom.x + scrgeom.width + x - width
   end

   if y >= 0 then
      y = scrgeom.y + y
   else
      y = scrgeom.y + scrgeom.height + y - height
   end

   wbox:geometry({ x = x, y = y})
end
