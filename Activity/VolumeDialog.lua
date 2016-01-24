
class 'VolumeDialog' (DisplayActivity)

function VolumeDialog:__init()
   DisplayActivity.__init(self, 'volume')
end

function VolumeDialog:register(pusher)
   LOG("VolumeDialog: register()")
   DisplayActivity.register(self, pusher)

   self.track_name      = self.line_a
   self.track_status    = self.line_d

   self.parameter_name  = self.line_b
   self.parameter_value = self.line_c

   self:handle_control('volume')

   self:mode_reset()

   local song = renoise.song()
   song.tracks_observable:add_notifier(self, VolumeDialog.ob_tracks_changed)
end

function VolumeDialog:mode_reset()
   self.mode = 'post'
end

function VolumeDialog:mode_next()
   local old = self.mode
   local new = old
   if old == 'post' then
      new = 'pre'
   elseif old == 'pre' then
      new = 'post'
   end
   self.mode = new
   self:update()
end

function VolumeDialog:ob_tracks_changed()
   self:update()
end

function VolumeDialog:on_dialog_show()
   self:mode_reset()
end

function VolumeDialog:on_button_press(control)
   local id = control.id
   if (id == 'volume') then
      self:mode_next()
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
   local tracks = song.tracks

   self:get_widget('volume'):set_color('full')

   for i, d in pairs(self.line_c) do
      d:set_text("")
   end

   local parameters = { }
   local names = { }
   for i, t in pairs(tracks) do
      names[i] = t.name
      if self.mode == 'post' then
         parameters[i] = t.postfx_volume
      elseif self.mode == 'pre' then
         parameters[i] = t.prefx_volume
      end
   end
   self.track_name[1]:set_split(names[1], names[2])
   self.track_name[2]:set_split(names[3], names[4])
   self.track_name[3]:set_split(names[5], names[6])
   self.track_name[4]:set_split(names[7], names[8])
   self.parameters = parameters
   self:update_parameters()
end
