import { shallowMount, createLocalVue } from "@vue/test-utils";
import UserIconTrim from "user_icon_trim";
import axios from "axios";
import Vue from "vue";
import Vuex from "vuex";
import "@testing-library/jest-dom"; // for toBeVisible()
const localVue = createLocalVue();
localVue.use(Vuex);

jest.mock("axios");
const responseGet = {
  data: false,
};
axios.get.mockImplementation((url) => {
  return Promise.resolve(responseGet);
});
const uploadCroppedImage = jest.fn();

describe("UserIconTrim", () => {
  let actions;
  let store;
  let wrapper;
  let open_field_icon;
  let close_field_icon;
  beforeEach(() => {
    actions = {
      pushFlash(context, payload) {
        context.commit("pushFlash", payload);
      },
    };
    store = new Vuex.Store({
      state: {
        flash: "",
        alertColor: "",
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
      },
      actions,
    });
    wrapper = shallowMount(UserIconTrim, {
      propsData: {
        userId: 1,
      },
      methods: { uploadCroppedImage },
      store,
      localVue,
    });
    open_field_icon = wrapper.find(".icon");
    close_field_icon = wrapper.find(".fa-times-circle");
  });
  it("shows icon", () => {
    expect(wrapper.html()).toContain(
      '<div class="fillter"></div> <i class="fas fa-camera-retro fa-2x"></i> <img src="[object Object]" class="icon-img">'
    );
  });
  it("shows upload field when user clicks icon", async () => {
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
  it("triggers function for trim when click the button", async () => {
    open_field_icon.trigger("click");
    await Vue.nextTick();
    wrapper.find(".btn").trigger("click");
    await Vue.nextTick();
    expect(uploadCroppedImage).toHaveBeenCalled();
  });
});
