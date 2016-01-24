--
-- PatternActivity - pattern browsing, control and editing
--

class 'PatternActivity' (PusherActivity)

function PatternActivity:__init()
   PusherActivity.__init(self, 'pattern')

   self.xoff = 0
   self.yoff = 0
end

function PatternActivity:register(pusher)
   LOG("PatternActivity: register()")
   PusherActivity.register(self, pusher)

   -- pads for sequencer display
   self:handle_control_group('pads')
   -- cursor for sequencer scrolling
   self:handle_control_group('cursor')

   local song = renoise.song()

   local sequencer = song.sequencer
   sequencer.pattern_assignments_observable:add_notifier(self, PatternActivity.update)
   sequencer.pattern_sequence_observable:add_notifier(self, PatternActivity.update)
   sequencer.selection_range_observable:add_notifier(self, PatternActivity.update)

   song.selected_track_index_observable:add_notifier(self, PatternActivity.update)
   song.selected_sequence_index_observable:add_notifier(self, PatternActivity.update)

   song.transport.playing_observable:add_notifier(self, PatternActivity.update_timer)

   self.timer_registered = false
   self:update_timer()
end

function PatternActivity:update_timer()
   local tool = renoise.tool()
   if (self.pusher:in_mode('pattern')) then
      if (not self.timer_registered) then
         tool:add_timer({self, PatternActivity.update}, 100)
         self.timer_registered = true
      end
   else
      if (self.timer_registered) then
         tool:remove_timer(PatternActivity.update)
         self.timer_registered = false
      end
   end
   self:update()
end

function PatternActivity:on_mode_change(mode)
   self:update_timer()
end

function PatternActivity:get_pad_context(pad)
   local patterns = renoise.song().patterns
   local sequencer = renoise.song().sequencer
   local tracks = renoise.song().tracks
   local patseq = sequencer.pattern_sequence
   local x = pad.x + self.xoff
   local y = (8 - pad.y) + 1 + self.yoff
   local validx = (x <= #tracks)
   local validy = (y <= #patseq)
   local valid = validx and validy
   local track = nil
   local pattern = nil
   local pattrack = nil
   if (validy) then
      pattern = patterns[patseq[y]]
   end
   if (validx) then
      track = tracks[x]
      if (pattern ~= nil) then
         pattrack = pattern:track(x)
      end
   end
   return { x = x, y = y,
            valid = valid,
            validx = validx,
            validy = validy,
            track = track,
            pattern = pattern,
            pattrack = pattrack }
end

function PatternActivity:update()
   local transport = renoise.song().transport
   local sequencer = renoise.song().sequencer
   local patterns = renoise.song().patterns
   local tracks = renoise.song().tracks

   local seltrack = renoise.song().selected_track_index

   local playpos = transport.playback_pos
   local editpos = transport.edit_pos

   local patseq = sequencer.pattern_sequence

   for pady in range(1,8) do
      for padx in range(1,8) do
         local pad = self:get_pad_top(padx, pady)
         local context = self:get_pad_context(pad)
         local x = context.x
         local y = context.y
         local pattern = context.pattern
         local track = context.pattrack
         if (y > #patseq or x > #tracks) then
            pad:set_color('off')
         elseif (x == seltrack and y == editpos.sequence) then
            pad:set_color('red')
         elseif (y == playpos.sequence) then
            if (track.is_empty) then
               pad:set_color('lime')
            else
               pad:set_color('green')
            end
         else
            if (track.is_empty) then
               pad:set_color('darkgrey')
            else
               pad:set_color('white')
            end
         end
      end
   end

   local c
   c = self.widgets['cursor-up']
   if (self.yoff > 0) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.widgets['cursor-down']
   if (self.yoff + 8 < #patseq) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.widgets['cursor-left']
   if (self.xoff > 0) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.widgets['cursor-right']
   if (self.xoff + 8 < #tracks) then
      c:set_color('on')
   else
      c:set_color('off')
   end
end

function PatternActivity:on_button_press(b)
   local patseq = renoise.song().sequencer.pattern_sequence
   local tracks = renoise.song().tracks
   -- cursor movement
   if (b.id == 'cursor-up') then
      self.yoff = math.max(self.yoff - 1, 0)
   end
   if (b.id == 'cursor-down') then
      self.yoff = math.max(0, math.min(self.yoff + 1, #patseq - 8))
   end
   if (b.id == 'cursor-left') then
      self.xoff = math.max(self.xoff - 1, 0)
   end
   if (b.id == 'cursor-right') then
      self.xoff = math.max(0, math.min(self.xoff + 1, #tracks - 8))
   end
   self:update()
end

function PatternActivity:on_pad_press(pad, value)
   local song = renoise.song()
   local context = self:get_pad_context(pad)
   if (context.validy) then
      LOG("PatternActivity: select_sequence(", context.y, ")")
      song.selected_sequence_index = context.y
      if (context.validx) then
         LOG("PatternActivity: select_track(", context.x, ")")
         song.selected_track_index = context.x
      end
      self:update()
   end
end

function PatternActivity:on_pad_release(pad, value)
end

function PatternActivity:on_pad_aftertouch(pad, value)
end
