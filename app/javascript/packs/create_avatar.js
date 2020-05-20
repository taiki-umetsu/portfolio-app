import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CreateAvatar from './components/create_avatar.vue'
import store from './store/index.js'
import 'vue-croppa/dist/vue-croppa.css'
import Croppa from 'vue-croppa'
Vue.use(Croppa)    


Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#create-avatar',
    store,
    components: { CreateAvatar }
  })
})