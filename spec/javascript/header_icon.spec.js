import { mount } from '@vue/test-utils'
import HeaderIcon from 'header_icon'
import '@testing-library/jest-dom'// for toBeVisible()
import Vue from 'vue'


describe('HeaderIcon for logged in user', () => {
  const wrapper = mount( HeaderIcon )
  wrapper.setProps({ userId: 1 })
  const vm = wrapper.vm
  it('has a user icon image', () => {
    expect(wrapper.html()).toContain("<img src=\"[object Object]\" class=\"user-icon\">")
  })
  it('shows nav-window-field after click icon', async () => {
    expect(vm.show).toBe(false)
    expect(wrapper.find('#nav-window-field').element).not.toBeVisible()
    const icon = wrapper.find('img')
    icon.trigger('click')
    await Vue.nextTick()
    expect(vm.show).toBe(true)
    expect(wrapper.find('#nav-window-field').element).toBeVisible()
    
  })
  it('shows links for logged in user', () => {
    expect(wrapper.text()).toBe('マイページ 設定 ログアウト')
    expect(wrapper.text()).not.toBe('テストログイン ログイン アカウント作成')
  })
})

describe('HeaderIcon for not logged in user', () => {
  const wrapper = mount( HeaderIcon )
  const vm = wrapper.vm
  it('does not have a user icon image', () => {
    expect(wrapper.html()).not.toContain("<img src=\"[object Object]\" class=\"user-icon\">")
  })
  it('shows nav-window-field after click icon', () => {
    expect(vm.show).toBe(false)
    expect(wrapper.find('#nav-window-field').element).not.toBeVisible()
    const icon = wrapper.find('.fa-bars')
    icon.trigger('click')
    expect(vm.show).toBe(true)
  })
  it('shows links for not logged in user', () => {
    expect(wrapper.text()).toBe('テストログイン ログイン アカウント作成')
    expect(wrapper.text()).not.toBe('マイページ 設定 ログアウト')
  })
})