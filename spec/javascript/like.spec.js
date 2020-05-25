import { mount, createLocalVue } from '@vue/test-utils'
import Like from 'infinite_scroll_avatars/like'
import axios from 'axios'
import Vuex from 'vuex'
import Vue from 'vue'
const localVue = createLocalVue()
localVue.use(Vuex)
jest.mock('axios')
const response_create = {'data': { 'like_id': 1 } }
const response_destroy = {'data': 'OK' }
const item =  {
  'avatar_id': 1,
  'avatar_public': false,
  'avatar_field': true,
  'created_at': '2020-05-24 17:10:45.333479 +0900',
  'user_name': 'user',
  'user_image': false,
  'user_id': 1,
  'like_count': 0,
  'like_id': false,
  'comment_id': false,
  'comment_count': 0,
  'comment_field': false,
  'message_board_field': false
}
axios.post.mockImplementationOnce((url) => {
  return Promise.resolve(response_create)
})
axios.delete.mockImplementationOnce((url) => {
  return Promise.resolve(response_destroy)
})
describe('Like', () => {
  let actions
  let store
  let wrapper
  let vm
  beforeEach(() => {
    actions = {
      updateList(context, payload){
        context.commit('updateList', payload)
      },
    }
    store = new Vuex.Store({
      state: {
        lists: {
          'avatarIndex' : [],
          'userShow' : [item],
          'userLiking' : [],
        },
      },
      mutations: {
        updateList(state,payload){
          for(let key in payload.data){
            Vue.set(state.lists[payload.keyName][payload.index1], key, payload.data[key])
          }
        },
      },
      actions
    })
    wrapper = mount( Like,{
      propsData: {
        keyName: 'userShow', index1: 0, item: item, currentUserId: 1
      },
      store, localVue,
    })
    vm = wrapper.vm
  })

  describe('logged in user', () => {
    it('shows icon to create like', () => {
      expect(wrapper.html()).toContain(
        "<div><i id=\"heart\" class=\"far fa-heart\"></i></div>"
      )
      expect(wrapper.html()).not.toContain(
        "<a href=\"/users/sign_in\">"
      )
      expect(wrapper.html()).not.toContain(
        "<div><i id=\"heart\" class=\"fas fa-heart\"></i></div>"
      )
    })
    it('success to create like', async () => {
      expect(wrapper.find(".heart-counter").text()).toBe('0')
      wrapper.find(".fa-heart").trigger('click')
      await Vue.nextTick()
      expect(axios.post).toHaveBeenCalled()
      await Vue.nextTick()
      expect(wrapper.find(".heart-counter").text()).toBe('1')
      expect(wrapper.html()).not.toContain(
        "<div><i id=\"heart\" class=\"far fa-heart\"></i></div>"
      )
      expect(wrapper.html()).toContain(
        "<div><i id=\"heart\" class=\"fas fa-heart\"></i></div>"
      )
    })
    it('success to destroy like', async () => {
      expect(wrapper.find(".heart-counter").text()).toBe('1')
      wrapper.find(".fa-heart").trigger('click')
      await Vue.nextTick()
      expect(axios.delete).toHaveBeenCalled()
      await Vue.nextTick()
      expect(wrapper.find(".heart-counter").text()).toBe('0')
      expect(wrapper.html()).toContain(
        "<div><i id=\"heart\" class=\"far fa-heart\"></i></div>"
      )
      expect(wrapper.html()).not.toContain(
        "<div><i id=\"heart\" class=\"fas fa-heart\"></i></div>"
      )
    })
  })
  
  describe('not logged in user', () => {
    beforeEach(() => {
      wrapper.setProps({ currentUserId: false })
    })
    it('does not show icon makes avatar public/private', () => {
      expect(wrapper.html()).toContain(
        "<a href=\"/users/sign_in\">"
      )
      expect(wrapper.html()).not.toContain(
        "<div><i id=\"heart\" class=\"far fa-heart\"></i></div>"
      )
      expect(wrapper.html()).not.toContain(
        "<div><i id=\"heart\" class=\"fas fa-heart\"></i></div>"
      )
    })
  })

})