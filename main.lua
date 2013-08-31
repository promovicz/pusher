
require "Globals"
require "Definitions"
require "Pitches"

require "OscClient"
require "OscVoiceMgr"

require "Pusher"
require "PusherActivity"
require "PusherControl"

require "Activity/RootActivity"
require "Activity/TransportActivity"
require "Activity/NotesActivity"

require "Control/Button"
require "Control/Dial"
require "Control/Display"
require "Control/Pad"

local pusher = Pusher("Ableton Push MIDI 1", "Ableton Push MIDI 1")

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Pusher:Start Pusher",
  invoke = function()
  end,
}
