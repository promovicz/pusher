
require "Globals"
require "Definitions"

require "Data/Characters"
require "Data/Pitches"
require "Data/PushColors"
require "Data/PushCommands"
require "Data/PushControls"
require "Data/PushDisplay"
require "Data/PushMode"
require "Data/PushRibbon"

require "OscClient"
require "OscVoiceMgr"

require "Core/Pusher"
require "Core/Activity"
require "Core/Control"
require "Core/Midi"
require "Core/Widget"

require "Activity/RootActivity"
require "Activity/TransportActivity"
require "Activity/PatternActivity"
require "Activity/NotesActivity"

require "Activity/DisplayActivity"
require "Activity/MasterDialog"
require "Activity/DeviceDialog"
require "Activity/ScaleDialog"
require "Activity/TrackDialog"

require "Activity/MixingDialog"
require "Activity/VolumeDialog"
require "Activity/PanSendDialog"

require "Control/Button"
require "Control/Dial"
require "Control/Display"
require "Control/Pad"
require "Control/Ribbon"

require "GUI/Tracks"

local pusher = nil

function start_pusher()
   if (pusher ~= nil) then
      pusher:release()
   end
   pusher = Pusher("Ableton Push MIDI 1", "Ableton Push MIDI 1")
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Pusher:Start Pusher",
  invoke = start_pusher
}

function timed_start()
   LOG("================================================================================")
   start_pusher()
   renoise.tool():remove_timer(timed_start)
end

renoise.tool():add_timer(timed_start,500)
