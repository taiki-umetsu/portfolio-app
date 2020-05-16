<template>
  <div>
    
  </div>
</template>

<script>
import axios from 'axios';
import { mapState } from 'vuex'
import { mapActions } from 'vuex'

export default {
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    ...mapState(['lists'])
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    index2: Number,
    baseUrl: String
  },
  methods: {
    ...mapActions(['updateList']),
  },
};
</script>

<style scoped>

</style>
