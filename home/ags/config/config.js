import Gio from "gi://Gio";
import { notificationPopup } from "./js/notifications/notifications.js";
// import { bar } from "./js/bar/bar.js";

const scss = App.configDir + "/style/main.scss";
const css = App.configDir + "/compiled.css";
function reloadScss() {
  print("Compiling and loading CSS...");
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
}
Utils.monitorFile(`${App.configDir}/style`, (_, eventType) => {
  if (eventType === Gio.FileMonitorEvent.CHANGED) reloadScss();
});
reloadScss();

export default {
  style: css,
  windows: [
    notificationPopup,
    // bar, # using ironbar for now
  ],
};
