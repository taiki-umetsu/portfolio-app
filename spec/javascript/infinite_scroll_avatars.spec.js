import { shallowMount, createLocalVue } from '@vue/test-utils'
import InfiniteScrollAvatars from 'infinite_scroll_avatars/infinite_scroll_avatars'
import '@testing-library/jest-dom'
import axios from 'axios'
import Vuex from 'vuex'


const localVue = createLocalVue()
localVue.use(Vuex)
jest.mock('axios')

const response1 = {
  'data' : {'userShow' : [
    {
      'avatar_id': 1,
      'avatar_public': true,
      'avatar_field': true,
      'created_at': '2020-05-24 17:10:45.333479 +0900',
      'user_name': 'user',
      'user_image': false,
      'user_id': 1,
      'like_count': 3,
      'like_id': false,
      'comment_id': false,
      'comment_count': 3,
      'comment_field': false,
      'message_board_field': false
    }
  ]}
}
const response2 = {
  'data' : {'userShow' : [
    {
      'avatar_id': 2,
      'avatar_public': true,
      'avatar_field': true,
      'created_at': '2020-05-24 17:15:45.333479 +0900',
      'user_name': 'user',
      'user_image': false,
      'user_id': 1,
      'like_count': 2,
      'like_id': 1,
      'comment_id': 1,
      'comment_count': 2,
      'comment_field': false,
      'message_board_field': false
    }
  ]}
}
axios.get.mockImplementationOnce((url) => {
  return Promise.resolve(response1)
}).mockImplementationOnce((url) => {
  return Promise.resolve(response2)
})
const infiniteHandler = jest.fn()


describe('InfiniteScrollAvatars', () => {
  let actions
  let store
  let wrapper

  beforeEach(() => {
    actions = {
      pushToList: jest.fn(),
      updateList: jest.fn(),
      resetList: jest.fn(),
      loading: jest.fn(),
      loaded: jest.fn(),
    }
    store = new Vuex.Store({
      state: {
        lists: {
          'avatarIndex' : [],
          'userShow' : [],
          'userLiking' : [],
        },
        flash: '',
        alertColor: '',
        formInputContent: '',
        loadingNow: '',
        collectionTab: true,
        likingTab: false,
      },
      actions
    })
    wrapper = shallowMount( InfiniteScrollAvatars,{
      store, localVue
    })
    wrapper.setProps({ currentUserId: 1, keyName: 'userShow', api: '/api/v1/users/1'})
    const vm = wrapper.vm
    
  })

  it('renders the correct markup', () => {
    expect(wrapper.html()).toContain("<div id=\"avatar-field\">")
  })

})
