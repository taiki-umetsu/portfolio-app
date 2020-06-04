import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import InfiniteScrollFollow from "./components/infinite_scroll_follow.vue";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("infinite-scroll-follow");
  if (el) {
    const app = new Vue({
      el: el,
      data: () => {
        return {};
      },
      components: { InfiniteScrollFollow },
    });
  }
});
