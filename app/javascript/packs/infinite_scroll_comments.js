import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Infinite from "./components/infinite_scroll_comments.vue";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("infinite-scroll-comments");
  if (el) {
    const app = new Vue({
      el: el,
      data: () => {
        return {};
      },
      components: { Infinite },
    });
  }
});
