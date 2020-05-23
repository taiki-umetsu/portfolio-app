import { mount } from '@vue/test-utils'
import GetUserIcon from 'get_user_icon'

describe('GetUserIcon', () => {
  it('renders the correct markup', () => {
    const wrapper = mount(GetUserIcon)
    expect(wrapper.html()).toContain("<img :src='icon' class='user-icon'>")
  })
})