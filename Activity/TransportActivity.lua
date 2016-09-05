
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

   self:handle_control('solo')
   self:handle_control('mute')

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

function TransportActivity:update_mode_button(button, mode)
   local w = self:get_widget(button)
   if self.pusher:in_mode(mode) then
      w:set_color('full')
   else
      w:set_color('half')
   end
end

function TransportActivity:update_dialog_button(button, dialog)
   local w = self:get_widget(button)
   if self.pusher:in_dialog(dialog) then
      w:set_color('full')
   else
      w:set_color('half')
   end
end

function TransportActivity:update()
   LOG("TransportActivity: update()")
   local song = renoise.song()
   local track = song.selected_track
   local transport = song.transport

   self:update_mode_button('note',    'notes')
   self:update_mode_button('session', 'pattern')

   self:update_dialog_button('master',  'master')
   self:update_dialog_button('volume',  'volume')
   self:update_dialog_button('pan-send', 'pansend')
   self:update_dialog_button('track',   'track')
   self:update_dialog_button('device',  'device')

   local solo = self:get_widget('solo')
   local mute = self:get_widget('mute')
   if track then
      local muted = (track.mute_state == renoise.Track.MUTE_STATE_OFF
                        or track.mute_state == renoise.Track.MUTE_STATE_MUTED)
      if muted then
         mute:set_color('full')
      else
         mute:set_color('half')
      end
      if track.solo_state then
         solo:set_color('full')
      else
         solo:set_color('half')
      end
   else
      mute:set_color('off')
      solo:set_color('off')
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
   local song = renoise.song()
   local track = song.selected_track
   local transport = song.transport

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

   if(id == 'note') then
      self.pusher:mode_note()
   end
   if(id == 'session') then
      self.pusher:mode_pattern()
   end

   if(id == 'master') then
      self.pusher:show_master_dialog()
   end
   if(id == 'volume') then
      self.pusher:show_volume_dialog()
   end
   if(id == 'pan-send') then
      self.pusher:show_pansend_dialog()
   end
   if(id == 'track') then
      self.pusher:show_track_dialog()
   end
   if(id == 'device') then
      self.pusher:show_device_dialog()
   end

   if(id == 'solo') then
      if track then
         track:solo()
      end
   end

   if(id == 'mute') then
      if track then
         if is_track_muted(track) then
            track:unmute()
         else
            track:mute()
         end
      end
   end

   if(id == 'tap-tempo') then
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
