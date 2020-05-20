import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import 'es6-promise/auto'


Vue.use(Vuex)
const store = new Vuex.Store({
  state: {
    lists: {
      'avatarIndex' : [],
      'userShow' : [],
      'userLiking' : [],
    },
    flash: '',
    alertColor: '',
    formInputContent: '',
  },
  mutations: {
    pushToList(state, payload) {
      for(let key in payload){
        state.lists[key].push(payload[key][0])
      }
    },
    updateList(state,payload){
      for(let key in payload.data){
        Vue.set(state.lists[payload.keyName][payload.index1], key, payload.data[key])
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
    destroyItem (state, payload) {
      state.lists[payload.keyName].splice(payload.index1,1);
    },
    resetList(state) {
      for(let key in state.lists){
        state.lists[key].splice(0,state.lists[key].length)
      }
    }
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
    destroyItem (context, payload) {
      context.commit('destroyItem', payload)
    },
    resetList (context) {
      context.commit('resetList')
    }
  }
})

export default store