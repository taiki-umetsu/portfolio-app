<template>
  <div>
    <div class="inline" id="likes">
      <div v-if="currentUserId == false">
        <a href="/users/sign_in">
          <i class="far fa-heart" id="heart"></i>
        </a>
      </div>
      <div v-else>
        <div v-if="item.like_id == false">
          <i class="far fa-heart" id="heart" @click="createLike"></i>
        </div>
        <div v-else>
          <i class="fas fa-heart" id="heart" @click="destroyLike"></i>
        </div>
      </div>
    </div>
    <div class="heart-counter inline">
      {{ item.like_count }}
    </div>
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
    ...mapActions(["updateList"]),
    destroyLike() {
      axios.delete(`/api/v1/likes/${this.item.like_id}`).then((response) => {
        if (response.data == "OK") {
          this.updateList({
            index1: this.index1,
            keyName: this.keyName,
            data: {
              like_count:
                this.lists[this.keyName][this.index1]["like_count"] - 1,
              like_id: false,
            },
          });
        }
      });
    },
    createLike() {
      axios
        .post("/api/v1/likes/", { avatar_id: this.item.avatar_id })
        .then((response) => {
          this.updateList({
            index1: this.index1,
            keyName: this.keyName,
            data: {
              like_count:
                this.lists[this.keyName][this.index1]["like_count"] + 1,
              like_id: response.data["like_id"],
            },
          });
        });
    },
  },
};
</script>

<style scoped>
.inline {
  float: left;
}
#like-field {
  margin: 0;
  padding: 0;
}
#likes {
  padding: 0;
  border-radius: 10px;
}
</style>
