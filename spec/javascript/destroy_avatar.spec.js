import { mount, createLocalVue } from "@vue/test-utils";
import DestroyAvatar from "infinite_scroll_avatars/destroy_avatar";
import axios from "axios";
import Vuex from "vuex";
import Vue from "vue";
import { mapState } from "vuex";

const localVue = createLocalVue();
localVue.use(Vuex);
jest.mock("axios");
const response = { data: "OK" };
const item = {
  avatar_id: 1,
  avatar_public: false,
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
axios.delete.mockImplementationOnce((url) => {
  return Promise.resolve(response);
});
window.confirm = jest.fn(() => true);

describe("Destroy", () => {
  let actions;
  let store;
  let wrapper;
  let vm;
  beforeEach(() => {
    actions = {
      pushFlash(context, payload) {
        context.commit("pushFlash", payload);
      },
      updateList(context, payload) {
        context.commit("updateList", payload);
      },
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
      },
      actions,
    });
    wrapper = mount(DestroyAvatar, {
      propsData: {
        keyName: "userShow",
        index1: 0,
        item: item,
        currentUserId: 1,
      },
      store,
      localVue,
      computed: {
        ...mapState(["flash"]),
      },
    });
    vm = wrapper.vm;
  });

  describe("avatar owner", () => {
    it("shows icon to destroy avatar", () => {
      expect(wrapper.html()).toContain(
        '<div><i class="far fa-trash-alt destroy-avatar"></i></div>'
      );
    });
    it("success to make avatar public", async () => {
      expect(vm.flash).not.toBe("アバターを削除しました");
      expect(vm.lists["userShow"][0].avatar_field).toBe(true);
      wrapper.find(".destroy-avatar").trigger("click");
      await Vue.nextTick();
      expect(axios.delete).toHaveBeenCalled();
      await Vue.nextTick();
      expect(vm.lists["userShow"][0].avatar_field).toBe(false);
      await Vue.nextTick();
      expect(vm.flash).toBe("アバターを削除しました");
    });
  });

  describe("not owner of avatar", () => {
    beforeEach(() => {
      wrapper.setProps({ currentUserId: 2 });
    });
    it("does not show icon makes avatar public/private", () => {
      expect(wrapper.html()).not.toContain(
        '<div><i class="fas fa-lock-open unlocked-icon lock-icon"></i></div>'
      );
      expect(wrapper.html()).not.toContain(
        '<div><i class="fas fa-lock locked-icon lock-icon"></i></div>'
      );
    });
  });
});
