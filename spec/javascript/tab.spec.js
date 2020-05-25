import { shallowMount, createLocalVue } from '@vue/test-utils'
import Tabs from 'tabs'
import Vuex from 'vuex'
import Vue from 'vue'
const localVue = createLocalVue()
localVue.use(Vuex)

describe('Tabs', () => {
  let actions
  let store
  let wrapper
  let vm
  beforeEach(() => {
    actions = {
      showCollectionTab(context) {
        context.commit('showCollectionTab')
      },
      showLikingTab (context) {
        context.commit('showLikingTab')
      },
      loading: jest.fn(),
      loaded: jest.fn(),
    }
    store = new Vuex.Store({
      state: {
        loadingNow: '',
        collectionTab: true,
        likingTab: false,
      },
      mutations: {
        showCollectionTab(state){
          if(window.scrollY==0){
            scrollTo(0, 1);
          };
          state.likingTab = false;
          state.collectionTab = true;
        },
        showLikingTab(state){
          if(window.scrollY==0){
            scrollTo(0, 1);
          };
          state.collectionTab = false;
          state.likingTab = true;
        },
      },
      actions
    })
    wrapper = shallowMount( Tabs,{
      propsData: {
        currentUserId: 1, userId: 1
      },
      store, localVue,
    })
    vm = wrapper.vm
  })

  it('shows tabs', () => {
    expect(wrapper.find(".active").html()).toContain(
      "<i class=\"fas fa-user-astronaut fa-lg tab-icon\"></i>"
    )
    expect(wrapper.find(".active").html()).not.toContain(
      "<i class=\"fas fa-heart fa-lg tab-icon\"></i>"
    )
    expect(vm.collectionTab).toBe(true)
    expect(vm.likingTab).toBe(false)
  })
  it('switches to liking tab', async () => {
    wrapper.find(".fa-heart").trigger('click')
    await Vue.nextTick()
    expect(wrapper.find(".active").html()).not.toContain(
      "<i class=\"fas fa-user-astronaut fa-lg tab-icon\"></i>"
    )
    expect(wrapper.find(".active").html()).toContain(
      "<i class=\"fas fa-heart fa-lg tab-icon\"></i>"
    )
    expect(vm.collectionTab).toBe(false)
    expect(vm.likingTab).toBe(true)
  })
})