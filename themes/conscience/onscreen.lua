-- Onscreen widgets module for Conscience theme

local infojets = require("infojets")
local pango = infojets.util.pango
local wibox = require("wibox")
local test = require("test")
local theme = require("beautiful")
local vicious = require("vicious")
local awful = awful
local onscreen = {}

function onscreen.init()
   onscreen.init_logwatcher()
   onscreen.init_processwatcher()
   onscreen.init_calendar()
   onscreen.init_jetclock()
   onscreen.init_test()
end


function onscreen.init_test()
   local wb = test.create_testbox(100,100, 150, 150, theme.bg_onscreen, theme.fg_onscreen)
   -- Initialize widget
   cpuwidget = wibox.widget.textbox()
-- Register widget
   vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")
   wb:set_widget(cpuwidget)
end
function onscreen.init_logwatcher()
   local wheight = 195
   local wb = infojets.create_wibox({ width = 695, height = wheight,
                                      x = 23, y = -29, bg_color = theme.bg_onscreen })
   w = infojets.logwatcher.new()
   w:add_log_directory('/home/unlogic', { { file = '.xsession-errors',
                                            mask = "(.+)" } })
   w:add_log_directory('/var/log', { 
                          { file = 'auth.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "crond:session" } 
                         },
                          { file = 'user.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)" 
                         },
                          { file = 'errors.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "dhcpcd", "sendmail" } 
                         },
                          { file = 'kernel.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (%w+: )%[%s*[%d%.]+%] (.+)" 
                         },
                          { file = 'messages.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "\\-\\- MARK \\-\\-",
                                       " kernel: " }
                         },
                          { file = 'pacman.log',
                            mask = "%[(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d)%](.+)" 
                         } 
                       })
   w.font = 'Helvetica 9'
   w.title_font = 'Helvetica 9'
   w:calculate_line_count(wheight)
   w.line_length = 120
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_processwatcher()
   local wheight = 193
   local wb = infojets.create_wibox({ width = 200, height = wheight,
                                      x = -26, y = -31, bg_color = theme.bg_onscreen })
   w = infojets.processwatcher.new()
   w:set_process_sorters({ { name = "Top CPU",
                             sort_by = "pcpu",
                             ignore = { "defunct", "migration" } },
                           { name = "Top memory",
                             sort_by = "rss",
                             ignore = { "defunct", "migration" } } })

   w.font = 'DejaVu Sans Mono 10'
   w.title_font = 'Helvetica 10'
   w:calculate_line_count(wheight)
   w.line_length = 40
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_jetclock()
   local scrwidth = 1280 -- For current display
   local radius = 132
   local wb = infojets.create_wibox({ width = radius * 2, height = radius * 2 + 95,
                                      x = scrwidth / 2 - radius - 2, y = 100, 
                                      bg_color = theme.bg_onscreen })
   w = infojets.jetclock.new(radius * 2, radius * 2 + 95, 100, radius)
   --w:set_radius(radius)
   remind = function(...) w:remind(...) end
   
   w:run()
   wb:set_widget(w.widget)
end

function onscreen.init_calendar()
   local wb = test.create_testbox(130,100, 0, 19, theme.bg_onscreen, theme.fg_onscreen)
   mytextbox = wibox.widget.textbox()
   mytextbox:set_text("toto")

   
   local orglendar = require('orglendar')
 orglendar.files = { "/home/glager/Cal.org"    -- Specify here all files you want to be parsed, separated by comma.
                     }
 lendartext = orglendar.in_place()
 mytextbox:set_markup(lendartext)
 
 wb:set_widget(mytextbox)
 orglendar.register(mytextbox)
end



return onscreen
