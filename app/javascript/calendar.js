import { createApp } from "vue";
import App from "./calendar.vue";

document.addEventListener("DOMContentLoaded", () => {
  const calendar = document.getElementById("calendar")
  const userId = calendar.getAttribute("value")
  createApp(App, {userId: userId}).mount("#calendar")
});
