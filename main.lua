
require "Globals"
require "Definitions"
require "Pitches"

require "Data/PushColors"
require "Data/PushCommands"
require "Data/PushControls"

require "OscClient"
require "OscVoiceMgr"

require "Pusher"
require "PusherActivity"
require "PusherControl"

require "Activity/RootActivity"
require "Activity/TransportActivity"
require "Activity/PatternActivity"
require "Activity/NotesActivity"
require "Activity/ScalesActivity"

require "Control/Button"
require "Control/Dial"
require "Control/Display"
require "Control/Pad"

local pusher = nil

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Pusher:Start Pusher",
  invoke = function()
     pusher = Pusher("Ableton Push MIDI 1", "Ableton Push MIDI 1")
  end,
}
