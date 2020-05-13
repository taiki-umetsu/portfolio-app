import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Infinite from '../infinite_scroll_avatars.vue'

   

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#infinite-scroll-avatars',
    data: () => {
      return {
      }
    },
    components: { Infinite }
  })
})