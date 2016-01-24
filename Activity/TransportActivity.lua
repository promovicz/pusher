
class 'TransportActivity' (PusherActivity)

function TransportActivity:__init()
   PusherActivity.__init(self, 'transport')
end

function TransportActivity:register(pusher)
   LOG("TransportActivity: register()")
   PusherActivity.register(self, pusher)

   self:handle_control('master')

   self:handle_control('volume')
   self:handle_control('pan-send')
   self:handle_control('track')
   self:handle_control('device')

   self:handle_control('note')
   self:handle_control('session')

   self:handle_control('master-knob')

   self:handle_control('tap-tempo')
   self:handle_control('tempo-knob')
   self:handle_control('metronome')

   self:handle_control('record')
   self:handle_control('play')

   local transport = renoise.song().transport
   transport.metronome_enabled_observable:add_notifier(self, TransportActivity.update)
   transport.edit_mode_observable:add_notifier(self, TransportActivity.update)
   transport.playing_observable:add_notifier(self, TransportActivity.update)
end

function TransportActivity:update()
   LOG("TransportActivity: update()")
   local transport = renoise.song().transport

   local c

   c = self:get_widget('note')
   if (self.pusher:in_mode('notes')) then
      c:set_color('full')
   else
      c:set_color('half')
   end
   c = self:get_widget('session')
   if (self.pusher:in_mode('pattern')) then
      c:set_color('full')
   else
      c:set_color('half')
   end

   self:get_widget('master'):set_color('full')

   c = self:get_widget('volume')
   if (self.pusher:in_dialog('volume')) then
      c:set_color('full')
   else
      c:set_color('half')
   end
   c = self:get_widget('pan-send')
   if (self.pusher:in_dialog('pan-send')) then
      c:set_color('full')
   else
      c:set_color('half')
   end
   c = self:get_widget('track')
   if (self.pusher:in_dialog('track')) then
      c:set_color('full')
   else
      c:set_color('half')
   end
   c = self:get_widget('device')
   if (self.pusher:in_dialog('device')) then
      c:set_color('full')
   else
      c:set_color('half')
   end

   local metronome = self:get_widget('metronome')
   local record = self:get_widget('record')
   local play = self:get_widget('play')

   if (transport.metronome_enabled) then
      metronome:set_color('full')
   else
      metronome:set_color('half')
   end
   if (transport.edit_mode) then
      record:set_color('full')
   else
      record:set_color('half')
   end
   if (transport.playing) then
      play:set_color('full')
   else
      play:set_color('half')
   end
end

function TransportActivity:on_mode_change(activity)
   LOG("TransportActivity: on_mode_change(", activity.id, ")")
   self:update()
end

function TransportActivity:on_button_press(control)
   local transport = renoise.song().transport

   local id = control.id
   if(id == 'metronome') then
      local enabled = transport.metronome_enabled
      transport.metronome_enabled = not enabled
   end
   if(id == 'record') then
      local enabled = transport.edit_mode
      transport.edit_mode = not enabled
   end
   if(id == 'play') then
      if transport.playing then
         transport.playing = false
      else
         local pos = transport.playback_pos.sequence
         transport:trigger_sequence(pos)
      end
   end
   if(id == 'tap-tempo') then
   end
   if(id == 'volume') then
      self.pusher:show_volume_dialog()
   end
   if(id == 'pan-send') then
   end
   if(id == 'track') then
      self.pusher:show_track_dialog()
   end
   if(id == 'device') then
      self.pusher:show_device_dialog()
   end
   if(id == 'note') then
      self.pusher:mode_note()
   end
   if(id == 'session') then
      self.pusher:mode_pattern()
   end

   self:update()
end

function TransportActivity:on_dial_change(control, change)
   local id = control.id

   if(id == 'tempo-knob') then
      local previous = renoise.song().transport.bpm
      local new
      if (change < 0) then
         new = math.max(BPM_MINIMUM, previous + change)
      else
         new = math.min(BPM_MAXIMUM, previous + change)
      end
      renoise.song().transport.bpm = new
   end
   if(id == 'master-knob') then
      local master = get_master_track()
      local v = master.prefx_volume
      local vold = v.value
      local vchg = change * 0.005
      if (vchg < 0) then
         v.value = math.max(v.value_min, vold + vchg)
      else
         v.value = math.min(v.value_max, vold + vchg)
      end
   end

   self:update()
end
