import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Tabs from './components/tabs.vue'
import CreateAvatar from './components/create_avatar.vue'
import 'vue-croppa/dist/vue-croppa.css'
import Croppa from 'vue-croppa'  
import store from './store/index.js'

Vue.use(TurbolinksAdapter)
Vue.use(Croppa)  

document.addEventListener('turbolinks:load', () => {
  const app1 = new Vue({
    el: '#tabs',
    store,
    components: { Tabs }
  })
})

document.addEventListener('turbolinks:load', () => {
  const app2 = new Vue({
    el: '#create-avatar',
    store,
    components: { CreateAvatar }
  })
})