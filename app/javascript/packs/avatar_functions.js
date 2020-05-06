import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Comment from '../avatar_comment.vue'
   

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#avatar-functions',
    data: () => {
      return {
      }
    },
    components: { Comment }
  })
})