
function show_simulator()
   local song = renoise.song()
   local vb = renoise.ViewBuilder()
   local tracks = vb:column {}

   local unit = 55

   local function build_knobs()
      local knobs = vb:row {}
      for x in range(1,8) do
         local knob = vb:rotary {
            width=unit,
            height=unit,
         }
         knobs:add_child(knob)
      end
      return knobs
   end

   local function build_display()
      local display = vb:column {}
      display:add_child(vb:row {height=0.15*unit})
      for y in range(1,4) do
         local line = vb:row {}
         for x in range(1,4) do
            local cell = vb:text {
               font='mono',
               align='center',
               text="ABCDEFGH IJKLMNOP",
               width = 2 * unit,
               height = 0.2 * unit,
            }
            line:add_child(cell)
         end
         display:add_child(line)
      end
      display:add_child(vb:row {height=0.15*unit})
      return display
   end

   local function build_buttons()
      local buttons = vb:column {}
      for y in range(1,2) do         local row = vb:row {}
         for x in range(1,8) do
            local button = vb:button {
               width=unit,
               height=0.5*unit,
            }
            row:add_child(button)
         end
         buttons:add_child(row)
      end
      return buttons
   end

   local function build_pads()
      local pads = vb:column {}
      for y in range(1,8) do
         local row = vb:row {}
         for x in range(1,8) do
            local pad = vb:button {
               width=unit,
               height=unit,
            }
            row:add_child(pad)
         end
         pads:add_child(row)
      end
      return pads
   end

   local push = vb:row {
      vb:column {

         vb:column {
            height=unit
         },

         vb:button {
            text = "Tempo",
            width = unit,
            height = 1.0 * unit,
         },
         vb:button {
            text = "Metro",
            width = unit,
            height = 0.6 * unit,
         },

         vb:rotary {
            width = unit,
            height = unit,
         },

         vb:column {
            height = 0.3 * unit,
         },

         vb:button {
            text = "Undo",
            width = unit,
            height = 0.6 * unit,
         },
         vb:button {
            text = "Delete",
            width = unit,
            height = 0.6 * unit,
         },
         vb:button {
            text = "Double",
            width = unit,
            height = 0.6 * unit,
         },
         vb:button {
            text = "Quant",
            width = unit,
            height = 0.6 * unit,
         },

         vb:column {
            height = 0.3 * unit,
         },

         vb:button {
            text = "Fixed",
            width = unit,
            height = 0.6 * unit,
         },
         vb:button {
            text = "Auto",
            width = unit,
            height = 0.6 * unit,
         },
         vb:button {
            text = "Dup",
            width = unit,
            height = 0.6 * unit,
         },

         vb:button {
            text = "New",
            width = unit,
            height = unit,
         },

         vb:column {
            height = 0.1 * unit,
         },

         vb:button {
            text = "Rec",
            width = unit,
            height = unit,
         },
         vb:button {
            text = "Play",
            width = unit,
            height = unit,
         },

      },
      vb:column {
         vb:column {
            height = 2.6 * unit,
         },
         vb:rotary {
            width = unit,
            height = unit,
         },
         vb:slider {
            width = unit,
            height = 8 * unit,
         },
      },

      vb:column {
         build_knobs(),
         build_display(),
         build_buttons(),
         build_pads(),
      },
      vb:column {
         vb:rotary {
            width = unit,
            height = unit,
         },
         vb:column {
            height = 1.6 * unit,
         },
         vb:button {
            text = "Master",
            height = 0.5 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "Stop",
            height = 0.5 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/32t",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/32",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/16t",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/16",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/8t",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/8",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/4t",
            height = 1 * unit,
            width = 1 * unit,
         },
         vb:button {
            text = "1/4",
            height = 1 * unit,
            width = 1 * unit,
         },
      },
      vb:column {
         vb:column {
            height = 1.0 * unit,
         },

         vb:row {
            vb:button {
               text = "Volume",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "PanSnd",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Track",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Clip",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Device",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Browse",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },

         vb:column {
            height = 0.15 * unit,
         },

         vb:row {
            vb:button {
               text = "->",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "<-",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Mute",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Solo",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Scales",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "User",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Repeat",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Accent",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "OctDn",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "OctUp",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },

         vb:row {
            vb:button {
               text = "AddFX",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "AddTrk",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Note",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Session",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },
         vb:row {
            vb:button {
               text = "Select",
               width = 1 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "Shift",
               width = 1 * unit,
               height = 0.5 * unit,
            },
         },

         vb:row {
            vb:column {
               width = 0.75 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "U",
               width = 0.5 * unit,
               height = 0.5 * unit,
            },
            vb:column {
               width = 0.75 * unit,
               height = 0.5 * unit,
            },
         },

         vb:row {
            vb:column {
               width = 0.25 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "L",
               width = 0.5 * unit,
               height = 0.5 * unit,
            },
            vb:column {
               width = 0.5 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "R",
               width = 0.5 * unit,
               height = 0.5 * unit,
            },
            vb:column {
               width = 0.25 * unit,
               height = 0.5 * unit,
            },
         },

         vb:row {
            vb:column {
               width = 0.75 * unit,
               height = 0.5 * unit,
            },
            vb:button {
               text = "D",
               width = 0.5 * unit,
               height = 0.5 * unit,
            },
            vb:column {
               width = 0.75 * unit,
               height = 0.5 * unit,
            },
         },

      },
   }

   renoise.app():show_custom_dialog("Push Simulator", push)
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Pusher:Simulator...",
  invoke = show_simulator
}
