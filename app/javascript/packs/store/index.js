import Vue from "vue/dist/vue.esm";
import Vuex from "vuex";
import "es6-promise/auto";

Vue.use(Vuex);
const store = new Vuex.Store({
  state: {
    lists: {
      avatarIndex: [],
      userShow: [],
      userLiking: [],
    },
    flash: "",
    alertColor: "",
    formInputContent: "",
    loadingNow: "",
    collectionTab: true,
    likingTab: false,
  },
  mutations: {
    unshiftToList(state, payload) {
      for (let key in payload) {
        state.lists[key].unshift(payload[key][0]);
      }
    },
    pushToList(state, payload) {
      for (let key in payload) {
        state.lists[key].push(payload[key][0]);
      }
    },
    updateList(state, payload) {
      for (let key in payload.data) {
        Vue.set(
          state.lists[payload.keyName][payload.index1],
          key,
          payload.data[key]
        );
      }
    },
    pushFlash(state, payload) {
      state.alertColor = payload.alertColor;
      state.flash = payload.flash;
      setTimeout(() => {
        state.flash = false;
        state.alertColor = false;
      }, 2000);
    },
    updateContent(state, content) {
      state.formInputContent = content;
    },
    destroyItem(state, payload) {
      state.lists[payload.keyName].splice(payload.index1, 1);
    },
    resetList(state) {
      for (let key in state.lists) {
        state.lists[key].splice(0, state.lists[key].length);
      }
    },
    resetLoadingNow(state) {
      state.loadingNow = "";
    },
    resetTab(state) {
      state.collectionTab = true;
      state.likingTab = false;
    },
    loading(state) {
      state.loadingNow++;
    },
    loadingWhenCreateAvatar(state) {
      state.loadingNow += state.lists["userShow"].length;
    },
    loaded(state) {
      state.loadingNow--;
    },
    showCollectionTab(state) {
      if (window.scrollY == 0) {
        scrollTo(0, 1);
      }
      state.likingTab = false;
      state.collectionTab = true;
    },
    showLikingTab(state) {
      if (window.scrollY == 0) {
        scrollTo(0, 1);
      }
      state.collectionTab = false;
      state.likingTab = true;
    },
  },
  actions: {
    unshiftToList(context, payload) {
      context.commit("unshiftToList", payload);
    },
    pushToList(context, payload) {
      context.commit("pushToList", payload);
    },
    updateList(context, payload) {
      context.commit("updateList", payload);
    },
    pushFlash(context, payload) {
      context.commit("pushFlash", payload);
    },
    updateContent(context, payload) {
      context.commit("updateContent", payload);
    },
    destroyItem(context, payload) {
      context.commit("destroyItem", payload);
    },
    resetList(context) {
      context.commit("resetList");
    },
    resetLoadingNow(context) {
      context.commit("resetLoadingNow");
    },
    resetTab(context) {
      context.commit("resetTab");
    },
    loading(context) {
      context.commit("loading");
    },
    loaded(context) {
      context.commit("loaded");
    },
    loadingWhenCreateAvatar(context) {
      context.commit("loadingWhenCreateAvatar");
    },
    showCollectionTab(context) {
      context.commit("showCollectionTab");
    },
    showLikingTab(context) {
      context.commit("showLikingTab");
    },
  },
});

export default store;
