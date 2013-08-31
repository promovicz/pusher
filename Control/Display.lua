
class 'PusherDisplay' (PusherControl)

function PusherDisplay:__init(id, index, clear_op, write_op)
   PusherControl.__init(self, 'display', id)
   self.index = index
   self.clear_op = clear_op
   self.write_op = write_op
   self.line = nil
   self.last_line = nil
end

function PusherDisplay:register(pusher)
   PusherControl.register(self, pusher)
   if (self.index < 3) then
      self:set_text_8({"abcdefghij", "cdefghijkl", "ef", "gh", "ij", "kl", "mn", "op"})
   else
      self:set_text_4({"abcd", "efgh", "ijkl", "mnop"})
   end
end

function PusherDisplay:update()
   if (self.invalid or self.last_line ~= self.line) then
      if (self.line == nil) then
         self:do_clear()
      else
         self:do_write()
      end
      self.last_line = self.line
      self.invalid = false
   end
end

function PusherDisplay:set_text(line)
   self.line = line
   self:update()
end

function PusherDisplay:format_parts(parts, num, each, justify)
   if (justify == nil) then
      justify = 0
   end
   local chunks = {}
   for i in range(1, num) do
      local part = parts[i]
      if (part == nil) then
         part = ""
      end
      chunks[i] = format_for_display(part, each, justify)
   end
   return chunks
end

function PusherDisplay:set_text_4(parts, justify)
   local chunks = self:format_parts(parts, 4, 17, justify)
   self:set_text(
      chunks[1] .. chunks[2] ..
      chunks[3] .. chunks[4]
   )
end

function PusherDisplay:set_text_8(parts, justify)
   local chunks = self:format_parts(parts, 8, 8, justify)
   self:set_text(
      chunks[1] .. " " .. chunks[2] ..
      chunks[3] .. " " .. chunks[4] ..
      chunks[5] .. " " .. chunks[6] ..
      chunks[7] .. " " .. chunks[8]
   )
end

function PusherDisplay:clear_text()
   self:set_text(nil)
end

function PusherDisplay:do_clear()
   self.pusher:send_sysex(
      SYSEX_START, self.clear_op)
end

function PusherDisplay:do_write()
   self.pusher:send_sysex(
      SYSEX_START, self.write_op, self.line, DISPLAY_WRITE_END)
end
