import { shallowMount, createLocalVue } from "@vue/test-utils";
import InfiniteScrollAvatars from "infinite_scroll_avatars/infinite_scroll_avatars";
import axios from "axios";
import Vuex from "vuex";
import Vue from "vue";
const localVue = createLocalVue();
localVue.use(Vuex);
jest.mock("axios");
const response = {
  data: {
    userShow: [
      {
        avatar_id: 1,
        avatar_public: true,
        avatar_field: true,
        created_at: "2020-05-24 17:10:45.333479 +0900",
        user_name: "user",
        user_image: false,
        user_id: 1,
        like_count: 3,
        like_id: false,
        comment_id: false,
        comment_count: 3,
        comment_field: false,
        message_board_field: false,
      },
    ],
  },
};
axios.get.mockImplementationOnce((url) => {
  return Promise.resolve(response);
});

describe("InfiniteScrollAvatars", () => {
  let actions;
  let store;
  let wrapper;
  let vm;
  beforeEach(() => {
    actions = {
      pushToList(context, payload) {
        context.commit("pushToList", payload);
      },
      updateList: jest.fn(),
      resetList: jest.fn(),
      loading: jest.fn(),
      loaded: jest.fn(),
    };
    store = new Vuex.Store({
      state: {
        lists: {
          avatarIndex: [],
          userShow: [],
          userLiking: [],
        },
      },
      mutations: {
        pushToList(state, payload) {
          for (let key in payload) {
            state.lists[key].push(payload[key][0]);
          }
        },
      },
      actions,
    });
    wrapper = shallowMount(InfiniteScrollAvatars, {
      store,
      localVue,
    });
    wrapper.setProps({
      currentUserId: 1,
      keyName: "userShow",
      api: "/api/v1/users/1",
    });
    vm = wrapper.vm;
  });

  it("renders the correct markup", () => {
    expect(wrapper.html()).toContain('<div id="avatar-field">');
  });

  it("shows avatar after infinite loading is handled ", async () => {
    expect(wrapper.html()).not.toContain(
      '<div class="wrapper shadow-sm col-12 col-md-6 offset-md-3 avatar1">'
    );
    vm.infiniteHandler();
    expect(axios.get).toHaveBeenCalled();
    expect(vm.lists["userShow"][0]).toBe(response["userShow"]);
    await Vue.nextTick();
    expect(wrapper.html()).toContain(
      '<div class="wrapper shadow-sm col-12 col-md-6 offset-md-3 avatar1">'
    );
  });
});
