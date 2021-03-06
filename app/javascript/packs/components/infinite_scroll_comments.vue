<template>
  <div>
    <div class="alert alert-success" v-show="flash">{{ flash }}</div>
    <div v-for="(list, $index1) in lists" :key="$index1">
      <div v-for="(item, $index2) in list" :key="$index2">
        <div class="wrapper-sm shadow" :class="setCommmentId(item['comment_id'])" id="comment-wrap">
          <div class="container">
            <div class="row d-flex align-items-center">
              <a :href="userPath(item['user_id'])">
                <get-user-icon :userId="item['user_id']" :baseUrl="baseUrl"></get-user-icon>
              </a>
              <a :href="userPath(item['user_id'])">
                <div id="user-name">{{ item["user_name"] }}</div>
              </a>
              <div id="comment-time">
                <time class="text-muted">{{ item["created_at"] | moment }}</time>
              </div>
            </div>
            <div class="row" id="comment-content">{{ item["content"] }}</div>
            <div
              v-show="commentedUser(item['user_id'])"
              id="icon-delete"
              @click="deleteComment(item['comment_id'], $index1, $index2)"
            >
              <i class="far fa-trash-alt"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <infinite-loading :distance="0" @infinite="infiniteHandler"></infinite-loading>
  </div>
</template>

<script>
import axios from "axios";
import InfiniteLoading from "vue-infinite-loading";
import moment from "moment";
import GetUserIcon from "./get_user_icon.vue";

export default {
  components: {
    InfiniteLoading,
    GetUserIcon
  },
  props: {
    avatarId: Number,
    baseUrl: String,
    currentUserId: Number
  },
  data() {
    return {
      comment_page: 1,
      lists: [],
      commentId: "",
      flash: ""
    };
  },
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    deleteLink() {
      return `/api/v1/comments/${this.commentId}`;
    }
  },
  methods: {
    infiniteHandler($state) {
      axios
        .get(`/api/v1/avatars/${this.avatarId}/comments`, {
          params: {
            comment_page: this.comment_page
          }
        })
        .then(response => {
          if (response.data.length) {
            this.comment_page += 1;
            this.lists.push(response.data);
            $state.loaded();
          } else {
            $state.complete();
          }
        });
    },
    setCommmentId(id) {
      return `comment${id}`;
    },
    commentedUser(commentUserId) {
      return commentUserId == this.currentUserId;
    },
    deleteComment(id, index1, index2) {
      if (confirm("コメントを削除してもよろしいですか？")) {
        axios.delete(`/api/v1/comments/${id}`).then(response => {
          if (response.data == "OK") {
            this.lists[index1].splice(index2, 1);
            this.showFlash();
          }
        });
      }
    },
    showFlash() {
      this.flash = "コメントを削除しました";
      setTimeout(() => {
        this.flash = false;
      }, 2000);
    },
    userPath(id) {
      return `/users/${id}`;
    }
  },
  filters: {
    moment: function(date) {
      moment.lang("ja");
      return moment(date).fromNow();
    }
  }
};
</script>

<style scoped>
#comment-field {
  width: 100%;
  height: 312px;
  overflow-y: scroll;
}
#comment-wrap {
  position: relative;
}

#user-name {
  margin-left: 10px;
}
#comment-time {
  margin-left: 10px;
  font-size: 12px;
}
#icon-delete {
  position: absolute;
  right: 2%;
  top: 2%;
}
.fa-trash-alt {
  font-size: 1em;
  color: gray;
}
.fa-trash-alt:hover {
  color: rgb(158, 157, 157);
}
#comment-content {
  font-size: 18px;
}
a {
  text-decoration: none;
  color: rgb(0, 0, 0);
}
a:hover {
  text-decoration: none;
  color: gray;
}
</style>
