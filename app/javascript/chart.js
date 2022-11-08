import { createApp } from "vue";
import App from "./chart.vue";
import store from '../../src/store';

document.addEventListener("DOMContentLoaded", () => {
  // const calendar = document.getElementById("calendar")
  // const userId = calendar.getAttribute("value")
  createApp(App).use(store).mount("#chart")
});
