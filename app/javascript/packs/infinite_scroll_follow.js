import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import InfiniteScrollFollow from "./components/infinite_scroll_follow.vue";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    el: "#infinite-scroll-follow",
    data: () => {
      return {};
    },
    components: { InfiniteScrollFollow },
  });
});
