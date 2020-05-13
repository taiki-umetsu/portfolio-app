
import InfiniteScroll from 'infinite-scroll';

var infScroll = new InfiniteScroll( '.infinite-container', {
  // options
  path: '.page-link',
  append: '.avatar-scroll',
  history: false,
});
