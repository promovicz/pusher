--
-- Representation of logical "widgets"
--
-- Each of these represents one specific function of a control.
--

class 'PusherWidget'

function PusherWidget:__init(activity, control)
   self.control = control
   self.id = control.id
   self.type = control.type

   self.aid = activity.id .. "_" .. control.id

   self.x = control.x
   self.y = control.y
   self.group = control.group
end

function PusherWidget:activate()
   if not self:is_active() then
      self.control.widget = self
      self:update()
   end
end

function PusherWidget:is_active()
   local c = self.control
   return c.widget ~= nil and c.widget.aid == self.aid
end

function PusherWidget:update()
   local c = self.control
   if self:is_active() then
      if c.set_color ~= nil then
         c:set_color(self.color)
      end
      if c.set_text ~= nil then
         c:set_text(self.text, self.justify)
      end
   end
end

function PusherWidget:set_color(color)
   self.color = color
   self:update()
end

function PusherWidget:set_text(text, justify)
   self.text = text
   self.justify = justify
   self:update()
end

function PusherWidget:set_split(ltext, rtext, ljust, rjust, separator)
   if (separator == nil) then
      separator = " "
   end
   local l = format_for_display(ltext, 8, ljust)
   local r = format_for_display(rtext, 8, rjust)
   self:set_text(l .. separator .. r, 0)
end
