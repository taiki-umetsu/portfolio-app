import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import InfiniteScrollUsers from "../components/infinite_scroll_users.vue";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("infinite-scroll-users");
  if (el) {
    const app = new Vue({
      el: el,
      data: () => {
        return {};
      },
      components: { InfiniteScrollUsers },
    });
  }
});
