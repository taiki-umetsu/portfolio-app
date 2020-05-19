<template>
    <div>
      <div v-if="currentUserId == item.user_id">
        <div v-if="item.avatar_public == false">
          <i class="fas fa-lock locked-icon lock-icon"
            @click="createPublic"
          ></i>
        </div>
        <div v-else>
          <i class="fas fa-lock-open unlocked-icon lock-icon"
            @click="destroyPublic"
          ></i>
        </div>
      </div>
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
    ...mapState(['lists', 'flash'])
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    baseUrl: String,
    keyName: String
  },
  methods: {
    ...mapActions(['updateList', 'pushFlash']),
    destroyPublic(){
      axios.patch(`/api/v1/avatars/${this.item.avatar_id}`, { 'avatar_public' : false })
        .then(response => {
          if(response.data=='OK'){
            this.updateList({
              'index1' : this.index1,
              'keyName' : this.keyName,
              'data' : { 'avatar_public' : false }
            })
            this.pushFlash({
              'flash' : '非公開モードです',
              'alertColor' : 'alert-success'
            })
          };
        })
    },
    createPublic(){
      axios.patch(`/api/v1/avatars/${this.item.avatar_id}`, { 'avatar_public' : true })
        .then(response => {
          if(response.data=='OK'){
            this.updateList({
              'index1' : this.index1,
              'keyName' : this.keyName,
              'data' : { 'avatar_public' : true }
            })
            this.pushFlash({
              'flash' : '公開モードです',
              'alertColor' : 'alert-success'
            })
          };
        })
    },
  },
};
</script>

<style scoped>

.unlocked-icon{
  padding:6px;
}
.locked-icon{
  padding:6px 5px 6px 7px;
}
.lock-icon{
  color:orange;
  width:28px;
  height:28px;
  margin-left:10px;
}

.lock-icon:hover {
    background-color: rgb(255, 225, 170);
    border-radius:15px;
}


</style>
