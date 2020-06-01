import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Infinite from "./components/infinite_scroll_avatars/infinite_scroll_avatars.vue";
import store from "./store/index.js";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    el: "#infinite-scroll-avatars",
    store,
    components: { Infinite },
  });
});
