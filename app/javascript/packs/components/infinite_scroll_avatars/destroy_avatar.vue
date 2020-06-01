<template>
  <div v-if="currentUserId == item['user_id']">
    <i class="far fa-trash-alt destroy-avatar" @click="destroyAvatar"></i>
  </div>
</template>

<script>
import axios from "axios";
import { mapState } from "vuex";
import { mapActions } from "vuex";

export default {
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    ...mapState(["lists"]),
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    baseUrl: String,
    keyName: String,
  },
  methods: {
    ...mapActions(["updateList", "pushFlash", "destroyItem"]),
    destroyAvatar() {
      if (confirm("アバターを削除してもよろしいですか？")) {
        axios
          .delete(`/api/v1/avatars/${this.item["avatar_id"]}`)
          .then((response) => {
            if (response.data == "OK") {
              this.updateList({
                index1: this.index1,
                keyName: this.keyName,
                data: {
                  avatar_field: false,
                },
              });
              this.pushFlash({
                flash: "アバターを削除しました",
                alertColor: "alert-success",
              });
            } else {
              this.pushFlash({
                flash: "アバターを削除できませんでした",
                alertColor: "alert-danger",
              });
            }
          });
      }
    },
  },
};
</script>

<style scoped>
.destroy-avatar {
  color: gray;
  padding: 6px 5px 6px 7px;
  width: 28px;
  height: 28px;
  margin-left: 10px;
}
.destroy-avatar:hover {
  background-color: rgb(204, 204, 204);
  border-radius: 15px;
}
</style>
