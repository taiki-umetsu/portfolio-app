import {render, fireEvent} from '@testing-library/vue'

test('there is no I in team', () => {
  expect('team').not.toMatch(/I/);
});