<template>
  <div id="avatar-field">
    <div v-for="(list, $index1) in lists" :key="$index1" >
      <div class="row" v-for="(item, $index2) in list" :key="$index2">
        <div class="wrapper shadow-sm col-6 offset-3" :class="setAvatarId(item['avatar_id'])" id="comment-wrap" >
          <div class="container">

            <div class="row d-flex align-items-center avatar-info">
              <a :href="userPath(item['user_id'])">
                <img :src="setImage(item['user_image'])" class="user-icon user-link" >
              </a>
              <a :href="userPath(item['user_id'])">
                <div id="user-name">{{item['user_name']}}</div>
              </a>
              <div id="avatar-time">
                <time class="text-muted">{{item['created_at'] | moment}}</time>
              </div>
            </div> 

            <div class="row" id="avatar-content">
              <iframe class="avatar-frame" :id="iframe($index1,$index2)" width="100%" height="400px" :src="avatarPath(item['avatar_id'])"></iframe>
            </div>

            <div class="row">
              <div class="heart-counter" id="likes">
                <div v-if="currentUserId == false">
                  <a href="/users/sign_in">
                    <i class="far fa-heart" id="heart"></i>
                  </a>
                </div>
                <div v-else>
                  <div v-if="item['like_id'] == false">
                    <i class="far fa-heart" id="heart" @click="createLike(item['avatar_id'],$index1,$index2)"></i>
                  </div>
                  <div v-else>
                    <i class="fas fa-heart" id="heart" @click="deleteLike(item['like_id'],$index1,$index2)" ></i>
                  </div>
                </div>
              </div>
              <div class='heart-counter'>
                {{item['like_count']}}
              </div>

              <div id="comments">
                <div v-if="currentUserId == false">
                  <a href="/users/sign_in">
                    <i class="far fa-comment" id="avatar-comment"></i>
                  </a>
                </div>
                <div v-else>
                  <div v-if="item['comment_id'] == false">
                    <i class="far fa-comment" id="avatar-comment" @click="showUploadField($index1,$index2)" ></i> 
                  </div>
                  <div v-else>
                    <i class="fas fa-comment" id="avatar-comment" @click="showUploadField($index1,$index2)" ></i> 
                  </div>
                </div>
              </div>
              <div class='comment-counter'>
                {{item['comment_count']}}
              </div>

              <transition name="slide-fade">
                <div class="upload-field" v-show="item['comment_field']">
                  <div class="comment-form container">            
                    <div class="row">
                      <div class="col-6 offset-3">
                        <div>
                          <transition name="slide-fade">
                            <i class="fas fa-times-circle fa-2x" @click="removeUploadField($index1,$index2)"></i>
                          </transition>
                          <textarea id="comment" v-model="commentContent" required="required" ></textarea>
                          <div class="comment-btn">
                            <button class="btn btn-primary" @click="createComment(item['avatar_id'],$index1,$index2)">コメントする</button>
                          </div>
                        </div>
                      </div>
                    </div>  
                  </div>
                </div>
              </transition>

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
    currentUserId: Number,
    baseUrl: String
  },
  data() {
    return {
      avatar_page: 1,
      lists: [],
      avatarId: "",
      flash:'',
      commentContent: '',
    };
  },
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
  },
  methods: {
    infiniteHandler($state) {
      axios.get('/api/v1/avatars', {
        params: {
          avatar_page: this.avatar_page
        },
      }).then(response => {
        if (response.data.length) {
          this.avatar_page += 1;
          this.lists.push(response.data);
          $state.loaded();
        } else {
          $state.complete();
        }
      });
    },
    setImage(image){
      return image? image : require("../assets/images/default_icon.png")
    },
    setAvatarId(avatar_id){
      return `avatar${avatar_id}`
    },
    avatarPath(avatar_id){
      return `/avatars/${avatar_id}`
    },
    userPath(user_id){
      return `/users/${user_id}`
    },
    iframe(index1,index2){
      return `iframe${index1}-${index1}`
    },
    deleteLike(like_id,index1,index2){
      axios.delete(`/api/v1/likes/${like_id}`)
        .then(response => {
          if(response.data=='OK'){
            let like_info = {
              'like_count' : this.lists[index1][index2]['like_count'] - 1,
              'like_id' : false
              };
            Object.assign(this.lists[index1][index2],like_info);
          };
        })
    },
    createLike(avatar_id,index1,index2){
      axios.post('/api/v1/likes/', { avatar_id: avatar_id},)
        .then(response => {
          let like_info = {
            'like_count' : this.lists[index1][index2]['like_count'] + 1,
            'like_id' : response.data['like_id']
            };
          Object.assign(this.lists[index1][index2],like_info);
        })
    },
    createComment(avatar_id,index1,index2){
      this.removeUploadField(index1,index2);
      axios.post('/api/v1/comments/', { avatar_id: avatar_id, content: this.commentContent},)
        .then(response => {
          let comment_info = {
            'comment_count' : this.lists[index1][index2]['comment_count'] + 1,
            'comment_id' : response.data['comment_id']
            };
          Object.assign(this.lists[index1][index2],comment_info);
          document.getElementById(`iframe${index1}-${index1}`).contentWindow.location.reload();
          this.commentContent = ''
        })
    },
    showUploadField(index1,index2){
      Object.assign(this.lists[index1][index2],{'comment_field' : true });

      
    },
    removeUploadField(index1,index2){
      Object.assign(this.lists[index1][index2],{'comment_field' : false });


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
  #avatar-time{
    margin-left:10px;
    font-size: 12px; 
  }

  .wrapper{
    margin-bottom: 30px;
  }
  .avatar-info{
    margin-bottom:10px;
  }
  a {
    text-decoration: none; 
    color: black;
  }
  a:hover {
    color: gray;
    text-decoration: none;
  }
  .user-link:hover{
    opacity: .8;
  }
  .avatar-frame{
    margin-bottom:10px;
  }
  #likes{
    padding:0;

    border-radius:10px;
  }
  .comment-counter{
    color: skyblue;
    padding:1.5px;
    margin-left:4px;
  }

  .upload-field {
    background-color: rgba(73, 73, 73, 0.5);
    width:100vw; 
    height: 100%;
    position: fixed;
    left: 50%;
    right: 50%;
    top: 40px;
    margin: 0 -50vw;
    z-index: 5;
  }
  .fa-times-circle {
    margin-top:50px;
    color: white;
  }
  .comment-form textarea{
    height:100px;
    margin-top:30px;
    border-radius: 10px;
  }
  .comment-form .comment-btn{
    width:100%;
    text-align: right;
  }
  .comment-form .btn{
    margin:0;
  }
  /* animation */
  .slide-fade-enter-active {
    transition: all .5s ease;
  }
  .slide-fade-leave-active {
    transition: all .2s cubic-bezier(1.0, 0.5, 0.8, 1.0);
  }
  .slide-fade-enter, .slide-fade-leave-to{
    transform: translateY(-300px);
    opacity: 0;
  }






</style>
