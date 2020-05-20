<template>
  <div>
    <div class="container">
      <div id="tabs" class="row d-flex align-items-center">
        <p class="col-6" @click="showCollectionTab">コレクション</p>
        <p class="col-6" @click="showLikingTab">いいね</p>
      </div>
    </div>


    <Infinite :base-url="baseUrl"
              :current-user-id="currentUserId"
              :api="`${apiUserShow}`"
              :key-name="'userShow'"
              v-show="collectionTab"
              @loaded="loaded"
    ></Infinite>

    <Infinite :base-url="baseUrl"
              :current-user-id="currentUserId"
              :api="`${apiUserLiking}`"
              :key-name="'userLiking'"
              v-show="likingTab"
              @loaded="loaded"
    ></Infinite>

  </div>  
</template>

<script>
import Infinite from './infinite_scroll_avatars/infinite_scroll_avatars.vue'

import axios from 'axios';
export default {
  props: {
    currentUserId: Number,
    userId: Number,
    baseUrl: String 
  },
  components: { Infinite },
  data() {
    return {
      collectionTab: true,
      likingTab: false,

    }
  },
  computed: {
    apiUserShow(){ return `/api/v1/users/${this.userId}` },
    apiUserLiking(){ return `/api/v1/users/${this.userId}/liking` },
  },
  methods: {
    showCollectionTab(){
      this.triggerInfiniteScroll()
      this.collectionTab = true;
      this.likingTab = false;
    },
    showLikingTab(){
      this.triggerInfiniteScroll()
      this.collectionTab = false;
      this.likingTab = true;

    },
    loaded(){
      
    },
    triggerInfiniteScroll(){
      if(window.scrollY==0){
        scrollTo(0, 1);
      };
    },
  },

}
</script>

<style scoped>
  #tabs {
    text-align: center;
  }

</style>
