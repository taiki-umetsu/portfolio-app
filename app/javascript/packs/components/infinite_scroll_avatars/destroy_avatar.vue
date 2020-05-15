<template>
  <div v-if="currentUserId == item['user_id']">
      <i class="far fa-trash-alt destroy-avatar"
        @click="destroyAvatar(item['avatar_id'], index1, index2)"
      ></i>
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
    ...mapActions(['updateList', 'pushFlash']),
    destroyAvatar(avatar_id,index1,index2){
      if(confirm('アバターを削除してもよろしいですか？')){
        axios.delete(`/api/v1/avatars/${avatar_id}`)
          .then(response => {
            if(response.data=='OK'){
              this.updateList({
                'index1' : index1,
                'index2' : index2,
                'data' : { 'avatar_field' : false }
              })
              this.pushFlash('アバターを削除しました')
            }else{
              this.pushFlash('アバターを削除できませんでした')
            };
          })
      };
    },
  }
};
</script>

<style scoped>
.destroy-avatar{
  color: gray;
  padding:6px 5px 6px 7px;
  width:28px;
  height:28px;
  margin-left:10px;
}
.destroy-avatar:hover {
  background-color:  rgb(204, 204, 204);
  border-radius:15px;
}

</style>
