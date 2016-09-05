
class 'PanSendDialog' (MixingDialog)

function PanSendDialog:__init()
   MixingDialog.__init(self, 'pansend')
end

function PanSendDialog:register(pusher)
   LOG("PanSendDialog: register()")
   MixingDialog.register(self, pusher)

   self:handle_control('pan-send')

   self.track_name      = self.line_a
   self.track_state     = self.line_d

   self.parameter_name  = self.line_b
   self.parameter_value = self.line_c

   self:mode_reset()
end

function PanSendDialog:mode_reset()
   self.mode = 'post'
end

function PanSendDialog:mode_next()
   local old = self.mode
   local new = old
   if old == 'post' then
      new = 'pre'
   elseif old == 'pre' then
      new = 'send'
   elseif old == 'send' then
      new = 'post'
   end
   self.mode = new
   self:update()
end

function PanSendDialog:on_dialog_show()
   MixingDialog.on_dialog_show(self)
   self:mode_reset()
end

function PanSendDialog:on_button_press(control)
   MixingDialog.on_button_press(self, control)
   local id = control.id
   if (id == 'pan-send') then
      self:mode_next()
   end
end

function PanSendDialog:update()
   LOG("PanSendDialog: update()")

   self:get_widget('pan-send'):set_color('full')

   if self.mode == 'post' or self.mode == 'pre' then
      self:update_pan()
   else
      self:update_send()
   end

   self:update_parameters()

   self:update_track_display()
   self:update_track_buttons()
end

function PanSendDialog:update_pan()
   local parameters = { }
   local names = { }

   local song = renoise.song()
   local tracks = song.tracks
   for i, t in pairs(tracks) do
      names[i] = t.name
      if self.mode == 'post' then
         parameters[i] = t.postfx_panning
      elseif self.mode == 'pre' then
         parameters[i] = t.prefx_panning
      end
   end

   self.parameters = parameters
end

function PanSendDialog:update_send()
   local parameters = { }
   local names = { }

   self.parameters = parameters
end
