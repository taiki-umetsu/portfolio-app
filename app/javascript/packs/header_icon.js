import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Icon from "./components/header_icon.vue";
Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    el: "#header-icon",
    components: { Icon },
  });
});
