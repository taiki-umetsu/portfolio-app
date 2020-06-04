import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import Tabs from "./components/tabs.vue";
import CreateAvatar from "./components/create_avatar.vue";
import "vue-croppa/dist/vue-croppa.css";
import Croppa from "vue-croppa";
import store from "./store/index.js";

Vue.use(TurbolinksAdapter);
Vue.use(Croppa);
//app1 and app2 share the store
document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("tabs");
  if (el) {
    const app1 = new Vue({
      el: el,
      store,
      components: { Tabs },
    });
  }
});

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("create-avatar");
  if (el) {
    const app2 = new Vue({
      el: el,
      store,
      components: { CreateAvatar },
    });
  }
});
