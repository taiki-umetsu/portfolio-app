<template>
  <div id="avatar-field">
    <div class="alert flash-message fixed-top" 
         :class="alertColor" 
         v-show="flash">{{flash}}
    </div>
    <div v-for="(list, $index1) in lists" :key="$index1" >
      <div class="row" v-for="(item, $index2) in list" :key="$index2">
        <div class="wrapper shadow-sm col-6 offset-3"
             :class="setAvatarId(item.avatar_id)"
             id="comment-wrap">
          <div class="container">
            <div class="row d-flex align-items-center avatar-info">
              <a :href="userPath(item.user_id)">
                <img :src="setImage(item.user_image)" class="user-icon user-link" >
              </a>
              <a :href="userPath(item.user_id)">
                <div id="user-name">{{item.user_name}}</div>
              </a>
              <div id="avatar-time">
                <time class="text-muted">{{item.created_at | moment}}</time>
              </div>
            </div> 

            <div class="row" id="avatar-content">
              <iframe class="avatar-frame" 
                :id="iframe($index1,$index2)"
                width="100%"
                height="400px"
                :src="avatarPath(item.avatar_id)"
              ></iframe>
            </div>

            <div class="row d-flex align-items-center">
              <Like :current-user-id="currentUserId"
                    :base-url="baseUrl"
                    :item='item'
                    :index1='$index1'
                    :index2='$index2'
              ></Like>
              <Comment :current-user-id="currentUserId"
                       :base-url="baseUrl"
                       :item='item'
                       :index1='$index1'
                       :index2='$index2'
              ></Comment>
              <Public :current-user-id="currentUserId"
                      :base-url="baseUrl"
                      :item='item'
                      :index1='$index1'
                      :index2='$index2'
              ></Public>
              <destroy-avatar :current-user-id="currentUserId"
                             :base-url="baseUrl"
                             :item='item'
                             :index1='$index1'
                             :index2='$index2'
              ></destroy-avatar>
              <message-board :current-user-id="currentUserId"
                             :base-url="baseUrl"
                             :item='item'
                             :index1='$index1'
                             :index2='$index2'
              ></message-board>
            </div>
          </div>
        </div>
      </div>
    </div>
    <infinite-loading :distance='500' @infinite="infiniteHandler" ></infinite-loading>
  </div>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';
import moment from "moment";
import Like from './like.vue';
import Comment from './comment.vue';
import Public from './public.vue';
import DestroyAvatar from './destroy_avatar.vue';
import MessageBoard from './message_board.vue';

import { mapState } from 'vuex';
import { mapActions } from 'vuex';

export default {
  computed: {
    ...mapState(['lists', 'flash', 'alertColor'])
  },
  components: {
    InfiniteLoading,
    Like,
    Comment,
    Public,
    DestroyAvatar,
    MessageBoard,
  },
  props: {
    currentUserId: Number,
    baseUrl: String
  },
  data() {
    return {
      avatar_page: 1,
    };
  },
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  methods: {
    ...mapActions(['pushToList', 'updateList']),
    infiniteHandler($state) {
      axios.get('/api/v1/avatars', {
        params: {
          avatar_page: this.avatar_page
        },
      }).then(response => {
        if (response.data.length) {
          this.avatar_page += 1;
          this.pushToList(response.data);
          $state.loaded();
        } else {
          $state.complete();
        }
      });
    },
    setImage(image){
      return image? image : require("../../../../assets/images/default_icon.png")
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
      return `iframe${index1}-${index2}`
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
</style>
