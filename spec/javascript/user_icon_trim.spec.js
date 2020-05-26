import { shallowMount } from '@vue/test-utils'
import UserIconTrim from 'user_icon_trim'
import axios from 'axios'
import Vue from 'vue'
import '@testing-library/jest-dom'// for toBeVisible()
jest.mock('axios')
const responseGet = {
  'data' : false
}
axios.get.mockImplementation((url) => {
  return Promise.resolve(responseGet)
})
const uploadCroppedImage = jest.fn()
 

describe('UserIconTrim', () => {
  let wrapper
  let open_field_icon
  let close_field_icon
  beforeEach(() => {
    wrapper = shallowMount(UserIconTrim, {
      propsData: {
        userId: 1,
      }, 
      methods:{uploadCroppedImage }
    })
    open_field_icon = wrapper.find('.icon')
    close_field_icon = wrapper.find('.fa-times-circle')
  })
  it('is icon', () => {
    expect(wrapper.html()).toContain(
      "<div class=\"fillter\"></div> <i class=\"fas fa-camera-retro fa-2x\"></i> <img src=\"[object Object]\" class=\"icon-img\">"
    )
  })
  it('shows upload field when user clicks icon', async () => {
    expect(wrapper.find('.upload-field').element).not.toBeVisible()
    open_field_icon.trigger('click')
    await Vue.nextTick()
    expect(wrapper.find('.upload-field').element).toBeVisible()
  })
  it('closes upload field when user clicks close field icon', async () => {
    open_field_icon.trigger('click')
    await Vue.nextTick()
    expect(wrapper.find('.upload-field').element).toBeVisible()
    close_field_icon.trigger('click')
    await Vue.nextTick()
    expect(wrapper.find('.upload-field').element).not.toBeVisible()
  })
  it('triggers function for trim when click the button', async () => {
    open_field_icon.trigger('click')
    await Vue.nextTick()
    wrapper.find('.btn').trigger('click')
    await Vue.nextTick()
    expect(uploadCroppedImage).toHaveBeenCalled()
  })
})