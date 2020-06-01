import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Infinite from "./components/infinite_scroll.vue";

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    el: "#infinite-scroll",
    data: () => {
      return {};
    },
    components: { Infinite },
  });
});
