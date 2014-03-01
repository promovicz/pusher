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
   PusherActivity.register(self, pusher)

   -- pads for sequencer display
   self:handle_control_group('pads')
   -- cursor for sequencer scrolling
   self:handle_control_group('cursor')

   local sequencer = renoise.song().sequencer

   local update = function()
      LOG("updating pattern")
      self:update()
   end

   sequencer.pattern_assignments_observable:add_notifier(update)
   sequencer.pattern_sequence_observable:add_notifier(update)
   sequencer.selection_range_observable:add_notifier(update)

   update()
end

function PatternActivity:update()
   LOG("pattern update")

   local sequencer = renoise.song().sequencer
   local patterns = renoise.song().patterns
   local tracks = renoise.song().tracks

   local patseq = sequencer.pattern_sequence

   for pady in range(1,8) do
      for padx in range(1,8) do
         local pad = self.pusher:get_pad_top(padx, pady)
         local x = padx + self.xoff
         local y = pady + self.yoff
         if (y > #patseq or x > #tracks) then
            pad:set_color('off')
         else
            local pattern = patterns[patseq[y]]
            if (pattern.is_empty) then
               pad:set_color('darkgrey')
            else
               local track = pattern:track(x)
               if (track.is_empty) then
                  pad:set_color('darkgrey')
               else
                  pad:set_color('white')
               end
            end
         end
      end
   end

   local c
   c = self.controls['cursor-up']
   if (self.yoff > 0) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.controls['cursor-down']
   if (self.yoff + 8 < #patseq) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.controls['cursor-left']
   if (self.xoff > 0) then
      c:set_color('on')
   else
      c:set_color('off')
   end
   c = self.controls['cursor-right']
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
