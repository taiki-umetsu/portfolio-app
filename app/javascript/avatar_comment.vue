<template>
  <div class="contents">
    <i class="far fa-comment avatar-comment" @click="selectedTab"></i>

    
    <div v-show="this.selected">
    <p> helo</p>
    <p> helo</p>
    <p> helo</p>
    <p> helo</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  props: {
  },
  data() {
    return {
      message: 'hello',
      selected:''
    }
  },
  computed: {
  },
  methods: {
    selectedTab(){
      this.selected = true;
    }
  }
}
</script>

<style scoped>
  .contents{
    margin-top:0px;
  }
  .avatar-comment{
    color: gray;
  }
</style>
