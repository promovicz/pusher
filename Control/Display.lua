--
-- Representation of the display
--
-- Display is organized as 4 lines with 4 segments each.
--
-- Each segment is comprised of 17 characters, which
-- makes it split nicely into two parts of 8 characters.
--
-- We therefore represent display cells of either 17 or 8 characters.
-- Activities can decide what variant to use.
--
-- Note that display updates are timer-driven as a special hack
-- to prevent update issues with older push firmwares.
--

class 'PusherDisplay'

function PusherDisplay:__init(index, clear_op, write_op)
   self.index = index
   self.clear_op = clear_op
   self.write_op = write_op
   self.line = nil
   self.last_line = nil
end

function PusherDisplay:register(pusher)
   self.pusher = pusher
   local cells = { }
   for i in range(1,4) do
      local cell = PusherDisplayCell(self, i, "display-" .. i .. "-" .. self.index)
      cell.group = "display"
      cells[i] = cell
      pusher:add_control(cell)
   end
   self.cells = cells
end

function PusherDisplay:pull()
   local parts = { }
   local justs = { }
   for i, c in pairs(self.cells) do
      parts[i] = c.text
      justs[i] = c.justify
   end
   self.line = self:format_line_4(parts, justs)
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

function PusherDisplay:invalidate()
   self.invalid = true
end

function PusherDisplay:format_parts(parts, num, each, justify)
   local chunks = {}
   for i in range(1, num) do
      local part = parts[i]
      local just = nil
      if (justify ~= nil) then
         just = justify[i]
      end
      chunks[i] = format_for_display(part, each, just)
   end
   return chunks
end

function PusherDisplay:format_line_4(parts, justify)
   local chunks = self:format_parts(parts, 4, 17, justify)
   return
      chunks[1] .. chunks[2] ..
      chunks[3] .. chunks[4]
end

function PusherDisplay:format_line_8(parts, justify)
   local chunks = self:format_parts(parts, 8, 8, justify)
   return
      chunks[1] .. " " .. chunks[2] ..
      chunks[3] .. " " .. chunks[4] ..
      chunks[5] .. " " .. chunks[6] ..
      chunks[7] .. " " .. chunks[8]
end

function PusherDisplay:do_clear()
   self.pusher:send_sysex(
      SYSEX_START, self.clear_op)
end

function PusherDisplay:do_write()
   self.pusher:send_sysex(
      SYSEX_START, self.write_op, self.line)
end


class 'PusherDisplayCell' (PusherControl)

function PusherDisplayCell:__init(display, index, id)
   PusherControl.__init(self, "display", id)
   self.display = display
   self.index = index
   self.text = ""
   self.justify = 0
end

function PusherDisplayCell:update()
   PusherControl.update(self)
   self.display:pull()
end

function PusherDisplayCell:clear()
   self:set_text()
end

function PusherDisplayCell:set_text(text, justify)
   if (text == nil) then
      text = ""
   end
   if (justify == nil) then
      justify = 0
   end
   self.text = text
   self.justify = justify
   self:update()
end
