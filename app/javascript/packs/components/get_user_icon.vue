<template>
  <img :src='icon' class="user-icon">
</template>

<script>
import axios from 'axios';
export default {
  props: {
    userId: Number,
    baseUrl: String 
  },
  data() {
    return {
      path: ''
    }
  },
  computed: {
    icon(){ return this.path ? this.path : require("../../../assets/images/default_icon.png") }
  },
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
    axios.get(`/api/v1/users/${this.userId}/image`)
      .then(response => (this.path = response.data))
  },
}
</script>

<style scoped>
  .user-icon{
    width: 40px;
    height: 40px;
    border-radius: 40px;
  }
</style>
