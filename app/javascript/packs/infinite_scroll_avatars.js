import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Infinite from './components/infinite_scroll_avatars/infinite_scroll_avatars.vue'
import Vuex from 'vuex'
import 'es6-promise/auto'

Vue.use(Vuex)
Vue.use(TurbolinksAdapter)
const store = new Vuex.Store({
  state: {
    lists: [],
    flash: '',
    alertColor: '',
    formInputContent: '',
  },
  mutations: {
    pushToList(state, payload) {
      state.lists.push(payload)
    },
    updateList(state,payload){
      for(let key in payload.data){
        Vue.set(state.lists[payload.index1][payload.index2], key, payload.data[key])
      }
    },
    pushFlash(state,payload) {
      state.alertColor = payload.alertColor;
      state.flash = payload.flash;
      setTimeout(() => {
        state.flash = false;
        state.alertColor = false;
      } ,2000 );
    },
    updateContent (state, content) {
      state.formInputContent = content
    },
  },
  actions: {
    pushToList(context, payload){
      context.commit('pushToList', payload)
    },
    updateList(context, payload){
      context.commit('updateList', payload)
    },
    pushFlash(context,payload){
      context.commit('pushFlash', payload)
    },
    updateContent (context, payload) {
      context.commit('updateContent', payload)
    },
  }
})

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#infinite-scroll-avatars',
    store,
    components: { Infinite }
  })
})