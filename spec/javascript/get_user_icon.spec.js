import { mount } from '@vue/test-utils'
import GetUserIcon from 'get_user_icon'
import axios from 'axios'
jest.mock('axios')
const response = {
  'data' : false
}
axios.get.mockImplementation((url) => {
  return Promise.resolve(response)
})

describe('GetUserIcon', () => {
  it('renders the correct markup', async() => {
    const wrapper = mount(GetUserIcon, {
      propsData: {
        userId: 1,
      }, 
      sync: false
    })
    const vm = wrapper.vm
    expect(axios.get).toHaveBeenCalledWith('/api/v1/users/1/image')
    expect(wrapper.html()).toContain("<img src=\"[object Object]\" class=\"user-icon\">")
  })
  
})