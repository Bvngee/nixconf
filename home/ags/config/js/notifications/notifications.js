const notifications = await Service.import("notifications");
const popups = notifications.bind("popups");

notifications.popupTimeout = 5000;
notifications.forceTimeout = false
// notifications.cacheActions = true; // what does this do?

/** @param {import("types/service/notifications").Notification} n */
function getIcon(n) {
  const { app_entry, app_icon, image } = n;

  if (image) {
    const output = Utils.exec(`identify -format "%w %h\n" ${image}`).split(' ');
    const w = parseInt(output[0]);
    const h = parseInt(output[1]);
    return Widget.Box({
      css: `
        background-image: url("${image}");
        background-size: cover; /*contain*/
        background-repeat: no-repeat;
        background-position: center;
        min-width: ${5 * (w / h)}em;
      `,
    });
  }
  if (Utils.lookUpIcon(app_icon)) return Widget.Icon(app_icon);
  if (app_entry && Utils.lookUpIcon(app_entry)) return Widget.Icon(app_entry);
  return null;
}

/** @param {import("types/service/notifications").Notification} n */
function mkNotification(n) {
  let hasIcon = false;
  const icon = Widget.Box({
    vpack: "center",
    class_name: "icon",
    setup: (self) => {
      const i = getIcon(n);
      if (i !== null) {
        self.child = i;
        hasIcon = true;
      }
    },
  });

  let hasAppIcon = false;
  const appIcon = Widget.Box({
    vpack: "center",
    class_name: "app-icon",
    setup: (self) => {
      if (Utils.lookUpIcon(n.app_name)) {
        self.child = Widget.Icon(n.app_name);
        hasAppIcon = true;
      }
    },
  });

  const appName = Widget.Label({
    class_name: "app-name",
    xalign: 0,
    justification: "left",
    hexpand: true,
    truncate: "end",
    wrap: false,
    label: n.app_name,
  });

  const title = Widget.Label({
    class_name: "title",
    xalign: 0,
    justification: "left",
    hexpand: true,
    // max_width_chars: 24,
    truncate: "end",
    wrap: true,
    label: n.summary,
    use_markup: true,
  });

  const body = Widget.Label({
    class_name: "body",
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: "left",
    label: n.body,
    wrap: true,
  });

  const actions = Widget.Box({
    class_name: "actions",
    children: n.actions.map(({ id, label }) =>
      Widget.Button({
        class_name: "action-button",
        on_clicked: () => n.invoke(id),
        hexpand: true,
        child: Widget.Label(label),
      }),
    ),
  });

  let hasBody = n.body.length > 0;
  const textInfo = Widget.Box({
    vertical: true,
    setup: (self) => {
      if (hasBody) {
        self.children = [title, body];
      } else {
        self.children = [title];
      }
    },
  });

  const appInfo = Widget.Box({
    vertical: false,
    class_name: "app-info",
    setup: (self) => {
      if (n.app_name !== "" && n.app_name !== null) {
        if (hasAppIcon) {
          self.children = [appIcon, appName];
        } else {
          self.children = [appName];
        }
      }
    },
  });

  const infoRight = Widget.Box({
    vertical: true,
    vpack: "center",
    // TODO: why wont this vexpand?
    children: [appInfo, textInfo],
    setup: (self) => {
      if (hasBody) {
        self.children = [appInfo, textInfo];
      } else {
        self.children = [appInfo, textInfo, actions];
      }
    },
  });

  // icon, appInfo, title, body
  const info = Widget.Box({
    class_name: "info",
    vertical: false,
    setup: (self) => {
      if (hasIcon) {
        self.children = [icon, infoRight];
      } else {
        self.children = [infoRight];
      }
    },
  });

  return Widget.EventBox({
    on_primary_click: () => n.dismiss(),
    // on_middle_click: () => popups.transform((popups) => {
    //   popups.forEach((n) => n.dismiss());
    // }),
    // on_secondary_click: () => n.dismiss(),
    child: Widget.Box({
      class_name: `notification ${n.urgency}`,
      vertical: true,
      // vexpand: true,
      // vpack: "fill", ?
      setup: (self) => {
        if (hasBody) {
          self.children = [info, actions];
        } else {
          self.children = [info];
        }
      },
    }),
  });
}

export const notificationPopup = Widget.Window({
  name: "notifications",
  anchor: ["top", "right"],
  child: Widget.Box({
    class_name: "notifications",
    vertical: true,
    children: popups.transform((popups) => {
      return popups.map((n) => mkNotification(n));
    }),
  }),
});
