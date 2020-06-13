<template>
  <div>
    <div>
      <div class="inline" id="comments">
        <div v-if="currentUserId == 0">
          <a href="/users/sign_in">
            <i class="far fa-comment" id="avatar-comment"></i>
          </a>
        </div>
        <div v-else>
          <div v-if="item.comment_id == false">
            <i class="far fa-comment" id="avatar-comment" @click="showField"></i>
          </div>
          <div v-else>
            <i class="fas fa-comment" id="avatar-comment" @click="showField"></i>
          </div>
        </div>
      </div>
      <a :href="link">
        <div class="comment-counter inline">{{ item.comment_count }}</div>
      </a>
    </div>
    <upload-field
      :index1="index1"
      :key-name="keyName"
      :fieldKeyName="'comment_field'"
      :btnText="'コメント'"
      :textAreaPlaceHolder="`${item.user_name}さんのアバターへコメント`"
      @submit="createComment"
    ></upload-field>
  </div>
</template>

<script>
import axios from "axios";
import { mapState } from "vuex";
import { mapActions } from "vuex";
import UploadField from "./upload_field.vue";
export default {
  components: {
    UploadField
  },
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    ...mapState(["lists", "flash", "alertColor", "formInputContent"]),
    link() {
      return this.currentUserId == 0
        ? "/users/sign_in"
        : `/avatars/${this.item.avatar_id}/comments`;
    }
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    baseUrl: String,
    keyName: String
  },
  methods: {
    ...mapActions(["updateList", "pushFlash", "updateContent", "loading"]),
    createComment() {
      if (!this.formInputContent || !this.formInputContent.match(/\S/g)) {
        this.pushFlash({
          flash: "フォームに入力してください",
          alertColor: "alert-danger"
        });
      } else {
        this.closeField();
        axios
          .post("/api/v1/comments/", {
            avatar_id: this.item.avatar_id,
            content: this.formInputContent
          })
          .then(response => {
            this.updateList({
              index1: this.index1,
              keyName: this.keyName,
              data: {
                comment_count:
                  this.lists[this.keyName][this.index1].comment_count + 1,
                comment_id: response.data.comment_id
              }
            });
            document
              .getElementById(`iframe${this.index1}`)
              .contentWindow.location.reload();
            this.loading();
            this.updateContent("");
            this.pushFlash({
              flash: "コメントしました！",
              alertColor: "alert-success"
            });
          });
      }
    },
    closeField() {
      this.updateList({
        index1: this.index1,
        keyName: this.keyName,
        data: { comment_field: false }
      });
    },
    showField() {
      this.updateList({
        index1: this.index1,
        keyName: this.keyName,
        data: { comment_field: true }
      });
    }
  }
};
</script>

<style scoped>
.inline {
  float: left;
}
#commetn-field {
  margin: 0;
  padding: 0;
}
.comment-counter {
  color: skyblue;
  padding: 1.5px;
  margin-left: 4px;
}
#avatar-comment {
  color: skyblue;
  padding: 6px;
  margin-left: 10px;
}
#avatar-comment:hover {
  background-color: rgb(212, 240, 251);
  border-radius: 15px;
}
</style>
