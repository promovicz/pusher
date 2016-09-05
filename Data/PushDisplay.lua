
-- Display Operations
--
-- This is used to send text to the LCD displays.
--
-- clearing: SYSEX_START DISPLAY_CLEAR[line]
-- writing:  SYSEX_START DISPLAY_WRITE[line] <string>
--

-- display clear, indexed by line offset
DISPLAY_CLEAR = {
 {28, 0, 0, 247},
 {29, 0, 0, 247},
 {30, 0, 0, 247},
 {31, 0, 0, 247}
}

-- display write, indexed by line offset
DISPLAY_WRITE = {
 {24, 0, 69, 0},
 {25, 0, 69, 0},
 {26, 0, 69, 0},
 {27, 0, 69, 0}
}
