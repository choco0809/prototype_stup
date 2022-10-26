import { createApp } from "vue";
import App from "./calendar.vue";

document.addEventListener("DOMContentLoaded", () => {
  const sample = document.getElementById("calendar")
  const msg = sample.getAttribute("value")
  createApp(App, {sample: msg}).mount("#calendar")
});
