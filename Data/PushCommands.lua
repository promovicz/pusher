-- Push command definitions

-- all push sysex commands begin with this
SYSEX_START = {240, 71, 127, 21}

-- variable-length commands use this terminator
SYSEX_END = {247}

-- Mode switching
--
-- The Push has two modes, "Live" mode and user mode.
--
-- Live mode is what Ableton uses, and so do we.
-- User mode is a simplified mode for easy custom mapping.
--
-- Send (SYSEX_START SET_MODE_xxx) to switch the mode.
--
SET_MODE_LIVE = {98, 0, 1, 0}
SET_MODE_USER = {98, 0, 1, 1}

-- Ribbon modes
RIBBON_SET_MODE = {99, 0, 1}
RIBBON_SET_LEDS = {100, 0, 8}

RIBBON_MODE_CUSTOM_PITCHBEND = 0
RIBBON_MODE_CUSTOM_VOLUME = 1
RIBBON_MODE_CUSTOM_PAN = 2
RIBBON_MODE_CUSTOM_DISCRETE = 3
RIBBON_MODE_CUSTOM_FREE = 4
RIBBON_MODE_PITCHBEND = 5
RIBBON_MODE_VOLUME = 6
RIBBON_MODE_PAN = 7
RIBBON_MODE_DISCRETE = 8

-- Display Operations
--
-- This is used to send text to the LCD displays.
--
-- clearing: SYSEX_START DISPLAY_CLEAR[line]
-- writing:  SYSEX_START DISPLAY_WRITE[line] <string> DISPLAY_WRITE_END
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
