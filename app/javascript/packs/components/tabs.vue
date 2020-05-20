<template>
  <div>
    <div class="col-md-6 offset-md-3 tabs-container" :class="{'fixed': isFixed}">
      <div class="container" >
        <div id="tabs" class="row d-flex align-items-center shadow-under">
          
          <button class="col-6" :class="{'active': collectionTab}"
            :disabled="loadingNowBoolean" @click="showCollectionTab">
              <i class="fas fa-user-astronaut fa-lg tab-icon"></i>
              <p v-show="loadingNow&&collectionTab">Loading</p>
          </button>
          <button class="col-6" :class="{'active': likingTab }"
            :disabled="loadingNowBoolean" @click="showLikingTab">
              <i class="fas fa-heart fa-lg tab-icon"></i>
              <p v-show="loadingNow&&likingTab">Loading</p>
          </button>
        </div>
      </div>
    </div>


    <div class="col-12">
      <Infinite :base-url="baseUrl"
                :current-user-id="currentUserId"
                :api="`${apiUserShow}`"
                :key-name="'userShow'"
                v-show="collectionTab"
                @loaded="loaded"
                @loading="loading"
      ></Infinite>

      <Infinite :base-url="baseUrl"
                :current-user-id="currentUserId"
                :api="`${apiUserLiking}`"
                :key-name="'userLiking'"
                v-show="likingTab"
                @loaded="loaded"
                @loading="loading"
      ></Infinite>
    </div>
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
      isFixed: false,
      loadingNow: ''
    }
  },
  mounted() {
    window.addEventListener('scroll', this.fixedPosition)
  },
  computed: {
    apiUserShow(){ return `/api/v1/users/${this.userId}` },
    apiUserLiking(){ return `/api/v1/users/${this.userId}/liking` },
    loadingNowBoolean(){ return this.loadingNow == 0 ? false : true }
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
      this.loadingNow--;
    },
    loading(){
      this.loadingNow++;
    },
    triggerInfiniteScroll(){
      if(window.scrollY==0){
        scrollTo(0, 1);
      };
    },
    fixedPosition(){
      if(window.scrollY > 200 ){
        this.isFixed = true
      }else{
        this.isFixed = false
      };
    },
  },

}
</script>

<style scoped>
  .tabs-container{
    padding:0;
  }
  #tabs {
    text-align: center;
  }
  #tabs p{
    margin-bottom: 0px;
  }
  .fixed{
    position: fixed;
    top:57px;
    left:0;
    background-color:#F8F9FF;
    padding:10px 0 0 0;
    z-index:2;
    width:100%;
  }
  .active{
    border-bottom: 1px solid black;
  }
  .active .tab-icon{
    color:black;
  }
  .tab-icon{
    color:gray;
  }
  .shadow-under{
    box-shadow: 0 4px 3px -3px lightgray;
  }
  button{
    background-color: transparent;
    border: none;
    cursor: pointer;
    outline: none;
    padding: 0;
    appearance: none;
  }

</style>
