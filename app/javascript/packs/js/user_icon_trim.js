import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Trim from "../components/user_icon_trim.vue";
import "vue-croppa/dist/vue-croppa.css";
import Croppa from "vue-croppa";
import store from "../store/index.js";
Vue.use(Croppa);

Vue.use(TurbolinksAdapter);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("trim");
  if (el) {
    const app = new Vue({
      el: el,
      store,
      components: { Trim },
    });
  }
});
