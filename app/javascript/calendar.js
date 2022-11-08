import { createApp } from "vue";
import App from "./calendar.vue";
import store from '../../src/store';

document.addEventListener("DOMContentLoaded", () => {
  const calendar = document.getElementById("calendar")
  const userId = calendar.getAttribute("value")
  createApp(App, {userId: userId}).use(store).mount("#calendar")
});
