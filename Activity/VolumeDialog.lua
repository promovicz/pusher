
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
   if (id == 'volume') then
   end
end
function VolumeDialog:on_dial_touch(control)
   if (control.group == 'knobs') then
   end
end
function VolumeDialog:on_dial_release(control)
   if (control.group == 'knobs') then
   end
end
function VolumeDialog:on_dial_change(control, change)
   if (control.group == 'knobs') then
      local parameter = self.parameters[control.x]
      self:adjust_parameter(parameter, change)
      self:update_parameters()
   end
end

function VolumeDialog:update()
   LOG("VolumeDialog: update()")

   local song = renoise.song()

   self:get_widget('volume'):set_color('full')

   local parameters = { }
   for i, t in pairs(song.tracks) do
      parameters[i] = t.prefx_volume
   end
   self.parameters = parameters
   self:update_parameters()
end
