import { shallowMount } from '@vue/test-utils'
import UserIconTrim from 'user_icon_trim'
import axios from 'axios'
import Vue from 'vue'
import '@testing-library/jest-dom'// for toBeVisible()
jest.mock('axios')
const responseGet = {
  'data' : false
}
const responsePatch = {
  'data' : { "content_type":"image/png", "disposition":"inline; filename=\"image.png\"; filename*=UTF-8''image.png", "encoded_key":"eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9JYTJWNVNTSWhabU53WlhKa2MzbGpablUzZW01cFoyMDJabU5zYTNJd1luaDRNZ1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpUFdsdWJHbHVaVHNnWm1sc1pXNWhiV1U5SW1sdFlXZGxMbkJ1WnlJN0lHWnBiR1Z1WVcxbEtqMVZWRVl0T0NjbmFXMWhaMlV1Y0c1bkJqc0dWRG9SWTI5dWRHVnVkRjkwZVhCbFNTSU9hVzFoWjJVdmNHNW5CanNHVkE9PSIsImV4cCI6IjIwMjAtMDUtMjVUMTM6MjE6MDkuOTU2WiIsInB1ciI6ImJsb2Jfa2V5In19--bfba46445ec4dc92ee76c986fe9527abac9f24d3", "filename":"image" }
}
axios.get.mockImplementation((url) => {
  return Promise.resolve(responseGet)
})
axios.patch.mockImplementation((url) => {
  return Promise.resolve(responsePatch)
})
const uploadCroppedImage = jest.fn(()=>{
  axios.patch('/api/v1/users/1')
  .then(response => (this.path = response.data))
})
 

describe('UserIconTrim', () => {
  let wrapper
  let vm
  let open_field_icon
  let close_field_icon
  beforeEach(() => {
    wrapper = shallowMount(UserIconTrim, {
      propsData: {
        userId: 1,
      }, 
      methods:{uploadCroppedImage }
    })
    vm = wrapper.vm
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
  it('makes a call to persist the image on image upload', async () => {
    open_field_icon.trigger('click')
    await Vue.nextTick()
    wrapper.find('.btn').trigger('click')
    await Vue.nextTick()
    expect(uploadCroppedImage).toHaveBeenCalled()

  })
})