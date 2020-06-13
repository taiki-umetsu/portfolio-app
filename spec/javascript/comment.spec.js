import { mount, createLocalVue } from "@vue/test-utils";
import Comment from "infinite_scroll_avatars/comment";
import "@testing-library/jest-dom"; // for toBeVisible()
import axios from "axios";
import Vuex from "vuex";
import Vue from "vue";
const localVue = createLocalVue();
localVue.use(Vuex);
jest.mock("axios");
const response = { data: { comment_id: 5 } };
const item = {
  avatar_id: 1,
  avatar_public: true,
  avatar_field: true,
  created_at: "2020-05-24 17:10:45.333479 +0900",
  user_name: "user",
  user_image: false,
  user_id: 1,
  like_count: 0,
  like_id: false,
  comment_id: false,
  comment_count: 0,
  comment_field: false,
  message_board_field: false,
};
axios.post.mockImplementationOnce((url) => {
  return Promise.resolve(response);
});

describe("Comment", () => {
  let actions;
  let store;
  let wrapper;
  let vm;
  let open_field_icon;
  let close_field_icon;
  beforeEach(() => {
    actions = {
      pushFlash(context, payload) {
        context.commit("pushFlash", payload);
      },
      updateList(context, payload) {
        context.commit("updateList", payload);
      },
      updateContent(context, payload) {
        context.commit("updateContent", payload);
      },
      resetList: jest.fn(),
      loading: jest.fn(),
    };
    store = new Vuex.Store({
      state: {
        lists: {
          avatarIndex: [],
          userShow: [item],
          userLiking: [],
        },
        flash: "",
        alertColor: "",
        formInputContent: "",
      },
      mutations: {
        pushFlash(state, payload) {
          state.alertColor = payload.alertColor;
          state.flash = payload.flash;
          setTimeout(() => {
            state.flash = false;
            state.alertColor = false;
          }, 2000);
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
        updateContent(state, content) {
          state.formInputContent = content;
        },
      },
      actions,
    });
    wrapper = mount(Comment, {
      propsData: {
        keyName: "userShow",
        index1: 0,
        item: item,
      },
      store,
      localVue,
    });
    vm = wrapper.vm;
    open_field_icon = wrapper.find(".fa-comment");
    close_field_icon = wrapper.find(".fa-times-circle");
  });

  describe("logged in user", () => {
    beforeEach(() => {
      wrapper.setProps({ currentUserId: 1 });
    });
    it("does not have link to login in comment icon", () => {
      expect(wrapper.html()).not.toContain(
        '<div><a href="/users/sign_in"><i id="avatar-comment" class="far fa-comment"></i></a></div>'
      );
    });
    it("shows upload field when user clicks open field icon", async () => {
      expect(wrapper.find(".upload-field").element).not.toBeVisible();
      open_field_icon.trigger("click");
      await Vue.nextTick();
      expect(wrapper.find(".upload-field").element).toBeVisible();
    });
    it("closes upload field when user clicks close field icon", async () => {
      open_field_icon.trigger("click");
      await Vue.nextTick();
      expect(wrapper.find(".upload-field").element).toBeVisible();
      close_field_icon.trigger("click");
      await Vue.nextTick();
      expect(wrapper.find(".upload-field").element).not.toBeVisible();
    });
    it("shows flash when user submit with empty comment", async () => {
      expect(vm.flash).not.toBe("フォームに入力してください");
      open_field_icon.trigger("click");
      await Vue.nextTick();
      wrapper.find(".btn").trigger("click");
      await Vue.nextTick();
      expect(axios.post).not.toHaveBeenCalled();
      await Vue.nextTick();
      expect(vm.flash).toBe("フォームに入力してください");
    });
    it("increments comment counter after user writes comment in textarea and submit", async () => {
      expect(wrapper.find(".comment-counter").text()).toBe("0");
      open_field_icon.trigger("click");
      await Vue.nextTick();
      wrapper.find("#content-form").setValue("コメント１");
      await Vue.nextTick();

      expect(vm.formInputContent).toBe("コメント１");
      wrapper.find(".btn").trigger("click");
      await Vue.nextTick();
      expect(axios.post).toHaveBeenCalled();
      await Vue.nextTick();
      expect(wrapper.find(".comment-counter").text()).toBe("1");
    });
  });

  describe("not logged in user", () => {
    beforeEach(() => {
      wrapper.setProps({ currentUserId: 0 });
    });
    it("has link to login in comment icon", () => {
      expect(wrapper.html()).toContain(
        '<div><a href="/users/sign_in"><i id="avatar-comment" class="far fa-comment"></i></a></div>'
      );
    });
  });
});
