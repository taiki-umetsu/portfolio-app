<template>
  <div>
    <div v-if="currentUserId == item.user_id">
      <i class="fas fa-pen-square message-board-icon" @click="showField"></i>
    </div>
    <upload-field
      :index1="index1"
      :key-name="keyName"
      :fieldKeyName="'message_board_field'"
      :btnText="'書き込む'"
      :textAreaPlaceHolder="'メッセージボードに書き込む'"
      @submit="updateMessageBoard"
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
    UploadField,
  },
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    ...mapState(["lists", "flash", "alertColor", "formInputContent"]),
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    baseUrl: String,
    keyName: String,
  },
  methods: {
    ...mapActions(["updateList", "pushFlash", "updateContent", "loading"]),
    updateMessageBoard() {
      if (!this.formInputContent || !this.formInputContent.match(/\S/g)) {
        this.pushFlash({
          flash: "フォームに入力してください",
          alertColor: "alert-danger",
        });
      } else {
        this.closeField();
        axios
          .patch(`/api/v1/avatars/${this.item["avatar_id"]}`, {
            message: this.formInputContent,
          })
          .then((response) => {
            if (response.data == "OK") {
              this.pushFlash({
                flash: "メッセージボードを更新しました",
                alertColor: "alert-success",
              });
            }
            document
              .getElementById(`iframe${this.index1}`)
              .contentWindow.location.reload();
            this.loading();
            this.updateContent("");
          });
      }
    },
    showField() {
      this.updateList({
        index1: this.index1,
        keyName: this.keyName,
        data: { message_board_field: true },
      });
    },
    closeField() {
      this.updateList({
        index1: this.index1,
        keyName: this.keyName,
        data: { message_board_field: false },
      });
    },
  },
};
</script>

<style scoped>
.message-board-icon {
  color: rgb(59, 255, 141);
  padding: 6px 5px 6px 7px;
  width: 28px;
  height: 28px;
  margin-left: 10px;
}
.message-board-icon:hover {
  background-color: rgb(176, 255, 209);
  border-radius: 15px;
}
</style>
