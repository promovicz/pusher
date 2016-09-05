
class 'VolumeDialog' (MixingDialog)

function VolumeDialog:__init()
   MixingDialog.__init(self, 'volume')
end

function VolumeDialog:register(pusher)
   LOG("VolumeDialog: register()")
   MixingDialog.register(self, pusher)

   self:handle_control('volume')

   self.track_name      = self.line_a
   self.track_state     = self.line_d

   self.parameter_name  = self.line_b
   self.parameter_value = self.line_c

   self:mode_reset()
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

function VolumeDialog:on_dialog_show()
   MixingDialog.on_dialog_show(self)
   self:mode_reset()
end

function VolumeDialog:on_button_press(control)
   MixingDialog.on_button_press(self, control)
   local id = control.id
   if (id == 'volume') then
      self:mode_next()
   end
end

function VolumeDialog:update()
   LOG("VolumeDialog: update()")

   local song = renoise.song()
   local tracks = song.tracks

   self:get_widget('volume'):set_color('full')

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

   self.parameters = parameters
   self:update_parameters()
   self:update_track_display()
   self:update_track_buttons()
end
