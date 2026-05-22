-- Require the sketchybar module
sbar = require("sketchybar")

-- Batch the entire config into an initial message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

-- Run the bar event loop
sbar.event_loop()
