
class 'MixingDialog' (DisplayActivity)

function MixingDialog:__init(id)
   DisplayActivity.__init(self, id)
end

function MixingDialog:register(pusher)
   LOG("MixingDialog: register()")
   DisplayActivity.register(self, pusher)

   self:handle_control_group('track-select')
   self:handle_control_group('track-state')

   local song = renoise.song()
   song.tracks_observable:add_notifier(self, self.update)
end

function MixingDialog:on_dialog_show()
   local song = renoise.song()
   local tracks = song.tracks
   for i, t in pairs(tracks) do
      t.mute_state_observable:add_notifier(self, self.update)
      t.solo_state_observable:add_notifier(self, self.update)
   end
end

function MixingDialog:on_dialog_hide()
   local song = renoise.song()
   local tracks = song.tracks
   for i, t in pairs(tracks) do
      t.mute_state_observable:remove_notifier(self.update)
      t.solo_state_observable:remove_notifier(self.update)
   end
end

function MixingDialog:on_button_press(control)
   local song = renoise.song()
   local tracks = song.tracks
   if control.group == 'track-select' then
      local track = tracks[control.x]
      if track then
         if is_track_muted(track) then
            track:unmute()
         else
            track:mute()
         end
      end
   end
   if control.group == 'track-state' then
      local track = tracks[control.x]
      if track then
         track:solo()
      end
   end
end

-- Helper to get track state
function MixingDialog:get_track_state(track)
   local solo = track.solo_state
   local mute = is_track_muted(track)
   if solo and mute then
      return "SOLO MUTE"
   elseif solo then
      return "SOLO"
   elseif mute then
      return "MUTE"
   else
      return "ACTIVE"
   end
end

-- Update track name and state display
function MixingDialog:update_track_display()
   local song = renoise.song()
   local tracks = song.tracks

   for i in range(0,3) do
      local idxa = i*2+1
      local idxb = i*2+2
      local tracka = tracks[idxa]
      local trackb = tracks[idxb]
      local name = self.track_name and self.track_name[i+1]
      local state = self.track_state and self.track_state[i+1]
      local namea = ""
      local nameb = ""
      local statea = ""
      local stateb = ""
      if tracka then
         namea = tracka.name
         statea = self:get_track_state(tracka)
      end
      if trackb then
         nameb = trackb.name
         stateb = self:get_track_state(trackb)
      end
      if name then
         name:set_split(namea, nameb)
      end
      if state then
         state:set_split(statea, stateb)
      end
   end
end

-- Update track state buttons
function MixingDialog:update_track_buttons()
   local song = renoise.song()
   local tracks = song.tracks

   for i in range(1,8) do
      local track = tracks[i]
      local mute = self:get_widget('track-select-'..i)
      local solo = self:get_widget('track-state-'..i)

      if track.mute_state == renoise.Track.MUTE_STATE_ACTIVE then
         mute:set_color('amber-half')
      elseif track.mute_state == renoise.Track.MUTE_STATE_MUTED then
         mute:set_color('amber-half-fast')
      elseif track.mute_state == renoise.Track.MUTE_STATE_OFF then
         mute:set_color('off')
      end

      if track.solo_state then
         solo:set_color('blue')
      else
         solo:set_color('off')
      end
   end
end
