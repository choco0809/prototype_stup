import { createApp } from "vue";
import App from "./chart.vue";

document.addEventListener("DOMContentLoaded", () => {
  // const calendar = document.getElementById("calendar")
  // const userId = calendar.getAttribute("value")
  createApp(App).mount("#chart")
});
