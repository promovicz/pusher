
class 'TransportActivity' (PusherActivity)

function TransportActivity:__init()
   PusherActivity.__init(self, 'transport')
end

function TransportActivity:register(pusher)
   PusherActivity.register(self, pusher)

   self:handle_control('metronome')
   self:handle_control('record')
   self:handle_control('play')
   self:handle_control('tempo-knob')
   self:handle_control('master-knob')
   self:handle_control('tap-tempo')

   local transport = renoise.song().transport

   local update = function()
      self:update()
   end

   transport.metronome_enabled_observable:add_notifier(update)
   transport.edit_mode_observable:add_notifier(update)
   transport.playing_observable:add_notifier(update)

   update()
end

function TransportActivity:update()
   local transport = renoise.song().transport

   local metronome = self.controls['metronome']
   local record = self.controls['record']
   local play = self.controls['play']

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
      LOG("master chg", vchg)
      if (vchg < 0) then
         v.value = math.max(v.value_min, vold + vchg)
      else
         v.value = math.min(v.value_max, vold + vchg)
      end
      LOG("master now", v.value)
   end

   self:update()
end
