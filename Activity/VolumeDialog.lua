
class 'VolumeDialog' (DisplayActivity)

function VolumeDialog:__init()
   DisplayActivity.__init(self, 'volume')
end

function VolumeDialog:register(pusher)
   LOG("VolumeDialog: register()")
   DisplayActivity.register(self, pusher)

   self.parameter_name  = self.line_a
   self.parameter_value = self.line_b

   self:handle_control('volume')

   local song = renoise.song()
   song.tracks_observable:add_notifier(self, VolumeDialog.update)
end

function VolumeDialog:on_button_press(control)
   local id = control.id
end

function VolumeDialog:update()
   LOG("VolumeDialog: update()")
end
