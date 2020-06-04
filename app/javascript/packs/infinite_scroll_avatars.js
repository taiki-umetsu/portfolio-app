import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Infinite from "./components/infinite_scroll_avatars/infinite_scroll_avatars.vue";
import store from "./store/index.js";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("infinite-scroll-avatars");
  if (el) {
    const app = new Vue({
      el: el,
      store,
      components: { Infinite },
    });
  }
});
