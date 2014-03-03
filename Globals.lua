
function TRACE(...)
   print(...)
end

function LOG(...)
   print(...)
end

function range(a, b, step)
  if not b then
    b = a
    a = 1
  end
  step = step or 1
  local f =
    step > 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue <= b then return nextvalue end
      end or
    step < 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue >= b then return nextvalue end
      end or
      function(_, lastvalue) return lastvalue end
  return f, nil, a - step
end

SPACES = {
   "",
   " ",
   "  ",
   "   ",
   "    ",
   "     ",
   "      ",
   "       ",
   "        ",
   "         ",
   "          ",
   "           ",
   "            ",
   "             ",
   "              ",
   "               ",
   "                ",
   "                 ",
   "                  ",
   "                   ",
   "                    "
}
DASHES = {
   "",
   "-",
   "--",
   "---",
   "----",
   "-----",
   "------",
   "-------",
   "--------",
   "---------",
   "----------",
   "-----------",
   "------------",
   "-------------",
   "--------------",
   "---------------",
   "----------------",
   "-----------------",
   "------------------",
   "-------------------"
}
PIPES = {
   "",
   "|",
   "||",
   "|||",
   "||||",
   "|||||",
   "||||||",
   "|||||||",
   "||||||||||",
   "|||||||||||",
   "||||||||||||",
   "|||||||||||||",
   "||||||||||||||",
   "|||||||||||||||",
   "||||||||||||||||",
   "|||||||||||||||||",
   "||||||||||||||||||",
   "|||||||||||||||||||",
   "||||||||||||||||||||"
}

function format_for_display(text, max, justify)
   if (text == nil) then
      text = ""
   end
   if (justify == nil) then
      justify = 0
   end
   if (#text == max) then
      return text
   elseif (#text > max) then
      return text:sub(1, max)
   elseif (#text < max) then
      if (justify == 0) then
         local fill = max - #text
         local left = 1
         local right = 1
         while (fill > 0) do
            if (fill > 0) then
               right = right + 1
               fill = fill - 1
            end
            if (fill > 0) then
               left = left + 1
               fill = fill - 1
            end
         end
         return SPACES[left] .. text .. SPACES[right]
      elseif (justify > 0) then
         return text .. SPACES[(max - #text) + 1]
      elseif (justify < 0) then
         return SPACES[(max - #text) + 1] .. text
      end
   end
end

function get_master_track()
  for i,v in pairs(renoise.song().tracks) do
    if v.type == renoise.Track.TRACK_TYPE_MASTER then
      return v
    end
  end
end

function get_master_track_index()
  for i,v in pairs(renoise.song().tracks) do
    if v.type == renoise.Track.TRACK_TYPE_MASTER then
      return i
    end
  end
end

function send_track(send_index)
  if (send_index <= renoise.song().send_track_count) then
    -- send tracks are always behind the master track
    local trk_idx = renoise.song().sequencer_track_count + 1 + send_index
    return renoise.song():track(trk_idx)
  else
    return nil
  end
end
