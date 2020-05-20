<template>
  <div>
    <div class="col-md-6 offset-md-3 tabs-container" :class="{'fixed': isFixed}">
      <div class="container" >
        <div id="tabs" class="row d-flex align-items-center shadow-under">
          
          <p class="col-6" :class="{'active': collectionTab}"
            @click="showCollectionTab">
              <i class="fas fa-user-astronaut fa-lg tab-icon"></i>
          </p>
          <p class="col-6" :class="{'active': likingTab }"
            @click="showLikingTab">
              <i class="fas fa-heart fa-lg tab-icon"></i>
          </p>
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
      ></Infinite>

      <Infinite :base-url="baseUrl"
                :current-user-id="currentUserId"
                :api="`${apiUserLiking}`"
                :key-name="'userLiking'"
                v-show="likingTab"
                @loaded="loaded"
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

    }
  },
  mounted() {
    window.addEventListener('scroll', this.fixedPosition)
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

</style>
