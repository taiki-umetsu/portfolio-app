import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Tabs from './components/tabs.vue'
import store from './store/index.js'
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#tabs',
    store,
    components: { Tabs }
  })
})
