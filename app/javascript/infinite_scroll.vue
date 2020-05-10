<template>
  <div id="comment-field">
    <div class="alert alert-success" v-show="flash">{{flash}}</div>
    <div v-for="(list, $index1) in lists" :key="$index1" >
      <div v-for="(item, $index2) in list" :key="$index2">
        {{setCommmentId(item['comment_id'])}}
        {{setImage(item['user_image'])}}
        {{commentedUser(item['user_id'])}}
        <div class="wrapper-sm shadow-sm" :class="eachComment" id="comment-wrap" >
          <div class="container">

            <div class="row d-flex align-items-center">
              <img v-bind:src="icon" class="user-icon" >
              <div id="user-name">{{item['user_name']}}</div>
              <div id="comment-time">
                <time class="text-muted">{{item['created_at'] | moment}}</time>
              </div>
            </div> 
            <div class="row" id="comment-content">
              {{item['content']}}
            </div>
            <div v-show="yourComment" id="icon-delete" @click="deleteComment(item['comment_id'],$index1,$index2)" >
              <i class="far fa-trash-alt"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <infinite-loading :distance='0' @infinite="infiniteHandler" ></infinite-loading>
  </div>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';
import moment from "moment";

export default {
  components: {
    InfiniteLoading,
  },
  props: {
    avatarId: Number,
    baseUrl: String ,
    currentUserId: Number
  },
  data() {
    return {
      comment_page: 1,
      lists: [],
      commentId: "",
      path: '',
      yourComment: '',
      flash:'',
    };
  },
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
     icon(){ return this.path ? this.path : require("../assets/images/default_icon.png") },
     deleteLink(){return `/api/v1/comments/${this.commentId}`},
     eachComment(){return `comment${this.commentId}`}
  },
  methods: {
    infiniteHandler($state) {
      axios.get(`/api/v1/avatars/${this.avatarId}`, {
        params: {
          comment_page: this.comment_page
        },
      }).then(response => {
        if (response.data.length) {
          this.comment_page += 1;
          this.lists.push(response.data);
          $state.loaded();
        } else {
          $state.complete();
        }
      });
    },
    setImage(image){
      this.path = image
    },
    setCommmentId(id){
      this.commentId = id
    },
    commentedUser(commentUserId){
      this.yourComment = commentUserId == this.currentUserId
    },
    deleteComment(id,index1,index2){
      if(confirm('コメントを削除してもよろしいですか？')){
        axios.delete(`/api/v1/comments/${id}`)
          .then(response => {
            if(response.data=='OK'){
              this.lists[index1].splice(index2,1);
              this.showFlash();};
          })
      };
    },
    showFlash(){
      this.flash = 'コメントを削除しました';
      setTimeout(() => {
        this.flash = false}
        ,3000
      )
    },
  },
  filters: {
    moment: function (date) {
      moment.lang('ja');
      return moment(date).fromNow();
    },
  },
};
</script>

<style scoped>
  #comment-field{
    width:100%;
    height:312px;
    overflow-y:scroll;
  }
  #comment-wrap{
  position: relative;
  }
  .user-icon{
    width: 40px;
    height: 40px;
    border-radius: 40px;
  }

  #user-name{
    margin-left:10px;
  }
  #comment-time{
    margin-left:10px;
    font-size: 12px; 
  }
  #icon-delete{
    position: absolute;
    right: 2%;
    top: 2%;
  }
  #comment-content{
    font-size: 18px; 
  }
</style>
