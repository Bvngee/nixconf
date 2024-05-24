import { nixSnowflake } from "../nix-snowflake-path.js";

const start = Widget.Box({
  hpack: "start",
  children: [
    // NixOS logo (powermenu)
    Widget.EventBox({
      on_primary_click: () => print('powermenu!'),
      child: Widget.Icon({
        icon: nixSnowflake,
        size: 20,
      })
    }),
  ]
});
const middle = Widget.Box({
  hpack: "center",
});
const end = Widget.Box({
  hpack: "end",
  children: [
    // clock
    Widget.EventBox({
      on_primary_click: () => Utils.execAsync("gnome-calendar"),
      child: Widget.Label().poll(1000, (self) => {
        self.label = Utils.exec('date "+%A %b %e, %-I:%M%P"');
      }),
    }),
  ],
});

export const bar = Widget.Window({
  name: "bar",
  anchor: ["top", "left", "right"],
  exclusivity: "exclusive",
  layer: "top",
  child: Widget.CenterBox({
    className: "bar",
    vertical: false,
    startWidget: start,
    centerWidget: middle,
    endWidget: end,
  }),
  // hpack: "fill",
  // halign: Gtk.Align.CENTER
});
