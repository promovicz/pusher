
class 'Pusher'

function Pusher:__init(port_in, port_out)
   -- create midi interface
   self.midi = PusherMidi(port_in, port_out)
   -- all controls
   self.controls = {}
   -- OSC client for note triggering
   self.osc_client = OscClient("127.0.0.1", 8000)
   self.voices = OscVoiceMgr(self.osc_client)
   -- activity variables
   self.activities = { }
   self.mode_activity = nil
   self.dialog_activity = nil
   -- display update counter
   self.display_updates = 0
   -- create controls and activities
   self:initialize_controls()
   self:initialize_activities()
   self:update()
   -- open MIDI links
   self:open()
end

function Pusher:open()
  LOG("Pusher: open()")
  -- open MIDI ports
  self.midi:open()
  -- initialize the controller
  self:initialize_device()
end

function Pusher:release()
  LOG("Pusher: release()")
  -- close MIDI ports
  self.midi:close()
end

function Pusher:in_mode(id)
   return self.mode_activity ~= nil
      and self.mode_activity.id == id
end
function Pusher:mode_note()
   self:set_mode(self.a_notes)
end
function Pusher:mode_pattern()
   self:set_mode(self.a_pattern)
end
function Pusher:set_mode(activity)
   LOG("Pusher: set_mode(" .. activity.id .. ")")
   if (self.mode_activity == nil
       or self.mode_activity.id ~= activity.id) then
      self.mode_activity = activity
      self:kill_dialog()
      self:update()
      self:mode_change(activity)
   end
end
function Pusher:mode_change(mode)
   for _, activity in pairs(self.activities) do
      activity:on_mode_change(mode)
   end
end

function Pusher:in_dialog(id)
   return self.dialog_activity ~= nil
      and self.dialog_activity.id == id
end
function Pusher:show_volume_dialog()
   self:show_dialog(self.d_volume)
end
function Pusher:show_track_dialog()
   self:show_dialog(self.d_track)
end
function Pusher:show_device_dialog()
   self:show_dialog(self.d_device)
end
function Pusher:show_scale_dialog()
   self:show_dialog(self.d_scale)
end
function Pusher:show_dialog(dialog)
   LOG("Pusher: show_dialog(" .. dialog.id .. ")")
   local old = self.dialog_activity
   if (old == nil or old.id ~= dialog.id) then
      self.dialog_activity = dialog
      self:dialog_change(old, dialog)
   end
end
function Pusher:hide_dialog(dialog)
   LOG("Pusher: hide_dialog(" .. dialog.id .. ")")
   if (self.dialog_activity == dialog) then
      self.dialog_activity = nil
      self:dialog_change(dialog, nil)
   end
end
function Pusher:kill_dialog()
   LOG("Pusher: kill_dialog()")
   local old = self.dialog_activity
   if (old ~= nil) then
      self.dialog_activity = nil
      self:dialog_change(old, nil)
   end
end
function Pusher:dialog_change(old, new)
   if (old ~= nil) then
      old:on_dialog_hide()
   end
   if (new ~= nil) then
      new:on_dialog_show()
   end
   self:update()
end

function Pusher:show_overlay(overlay)
   LOG("Pusher: show_overlay(" .. overlay.id .. ")")
end
function Pusher:hide_overlay(overlay)
   LOG("Pusher: hide_overlay(" .. overlay.id .. ")")
end
function Pusher:kill_overlay()
   LOG("Pusher: kill_overlay()")
end

-- get the topmost handler for the control with the given id
function Pusher:get_control_handler(id)
   for _, activity in pairs(self.activities) do
      if (activity ~= nil) then
         local control = activity.controls[id]
         if (control ~= nil) then
            return activity
         end
      end
   end
   return nil
end

-- delegations to MIDI interface
function Pusher:register_cc(cc, control)
   self.midi:register_cc(cc, control)
end
function Pusher:register_note(key, control)
   self.midi:register_note(key, control)
end
function Pusher:register_bend(control)
   self.midi:register_bend(control)
end
function Pusher:send_sysex(...)
   self.midi:send_sysex(...)
end
function Pusher:send_cc(number, value, channel)
   self.midi:send_cc(number, value, channel)
end
function Pusher:send_note(key, velocity, channel)
   self.midi:send_note(key, velocity, channel)
end

-- adds a control
function Pusher:add_control(control)
   if (control.group == nil) then
      control.group = 'none'
   end

   --LOG("control", control.id, "in group", control.group)

   self.controls[control.id] = control
   control:register(self)
end

-- get the control with the given id
function Pusher:get_control(id)
   return self.controls[id]
end

-- get all controls with the given group id
function Pusher:get_control_group(group_id)
   local result = table.create()
   for _, control in pairs(self.controls) do
      if (control.group == group_id) then
         result:insert(control)
      end
   end
   return result
end

-- create and register all controls
function Pusher:initialize_controls()
  LOG("Pusher: initialize_controls()")
  -- buttons
  for _, b in pairs(BUTTONS) do
     local p = b.palette
     if (p == nil) then
        p = 'simple'
     end
     local c = PusherButton(b.id, b.cc, PALETTES[p])
     c.group = b.group
     c.x = b.x
     c.y = b.y
     self:add_control(c)
  end
  -- dials
  for _, def in pairs(DIALS) do
     local dial = PusherDial(def.id, def.cc, def.note)
     dial.group = def.group
     dial.x = def.x
     dial.y = def.y
     self:add_control(dial)
  end
  -- display
  local displays = { }
  for index in range(1, 4) do
     local display = PusherDisplay(index,
                                   DISPLAY_CLEAR[index],
                                   DISPLAY_WRITE[index])
     displays[index] = display
     display:register(self)
  end
  renoise.tool():add_timer({self, self.update_displays}, 100)
  self.displays = displays
  -- ribbon
  local ribbon = PusherRibbon('ribbon', 12)
  self.ribbon = ribbon
  self:add_control(ribbon)
  -- pads
  local pads = { }
  for y in range(0, 7) do
     local padline = { }
     local palette = PALETTES['rgb']
     for x in range(0, 7) do
        local id = ("pad-%d-%d"):format(x + 1, y + 1)
        local p = PusherPad(id, x + 1, y + 1, 36 + x + (y * 8), palette)
        p.group = 'pads'
        self:add_control(p)
        padline[x + 1] = p
     end
     pads[y + 1] = padline
  end
  self.pads = pads
end

-- initialize all activities
function Pusher:initialize_activities()
   LOG("Pusher: initialize_activities()")
   -- create activities
   self.a_root = self:initialize_activity(RootActivity)
   self.a_transport = self:initialize_activity(TransportActivity)
   self.a_notes = self:initialize_activity(NotesActivity)
   self.a_pattern = self:initialize_activity(PatternActivity)

   self.d_device = self:initialize_activity(DeviceDialog)
   self.d_scale = self:initialize_activity(ScaleDialog)
   self.d_track = self:initialize_activity(TrackDialog)
   self.d_volume = self:initialize_activity(VolumeDialog)

   self.mode_activity = self.a_notes
end
function Pusher:initialize_activity(class)
   local instance = class()
   instance:register(self)
   return instance
end

-- initialize the controller
function Pusher:initialize_device()
  LOG("Pusher: initialize_device()")
  -- switch device to live native mode
  self:send_sysex(SYSEX_START, SET_MODE_LIVE)
  -- invalidate and update all controls
  for i, c in pairs(self.controls) do
     c:invalidate()
     c:update()
  end
end

function Pusher:update_activities()
   local activities = table.create()

   if (self.dialog_activity ~= nil) then
      activities[#activities+1] = self.dialog_activity
   end
   if (self.mode_activity ~= nil) then
      activities[#activities+1] = self.mode_activity
   end

   activities[#activities+1] = self.a_transport
   activities[#activities+1] = self.a_root

   self.activities = activities
end

-- update all controls
function Pusher:update()
   LOG("Pusher: update()")

   self:update_activities()

   local activities = self.activities

   for i = #activities,1,-1 do
      local a = activities[i]
      if (a ~= nil) then
         a:activate()
      end
   end
   for i = #activities,1,-1 do
      local a = activities[i]
      if (a ~= nil) then
         a:redraw()
      end
   end
   for i = #activities,1,-1 do
      local a = activities[i]
      if (a ~= nil) then
         a:update()
      end
   end
end

-- update displays
function Pusher:update_displays()
   self.display_updates = self.display_updates + 1
   local invalidate = (self.display_updates % 10 == 0)
   -- update display
   for i, d in pairs(self.displays) do
      if (invalidate) then
         d:invalidate()
      end
      d:update()
   end
end
