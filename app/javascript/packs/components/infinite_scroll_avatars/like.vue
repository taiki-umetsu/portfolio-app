<template>
  <div>
    <div class="inline" id="likes">
      <div v-if="currentUserId == 0">
        <a href="/users/sign_in">
          <i class="far fa-heart" id="heart"></i>
        </a>
      </div>
      <div v-else>
        <div v-if="item.like_id == false" @click="createLike">
          <i class="far fa-heart" id="heart"></i>
        </div>
        <div v-else @click="destroyLike">
          <i class="fas fa-heart" id="heart"></i>
        </div>
      </div>
    </div>
    <a :href="link">
      <div class="heart-counter inline">{{ item.like_count }}</div>
    </a>
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
    link() {
      return this.currentUserId == 0
        ? "/users/sign_in"
        : `/avatars/${this.item.avatar_id}/likers`;
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
    ...mapActions(["updateList"]),
    destroyLike() {
      axios.delete(`/api/v1/likes/${this.item.like_id}`).then(response => {
        if (response.data == "OK") {
          this.updateList({
            index1: this.index1,
            keyName: this.keyName,
            data: {
              like_count:
                this.lists[this.keyName][this.index1]["like_count"] - 1,
              like_id: false
            }
          });
        }
      });
    },
    createLike() {
      axios
        .post("/api/v1/likes/", { avatar_id: this.item.avatar_id })
        .then(response => {
          this.updateList({
            index1: this.index1,
            keyName: this.keyName,
            data: {
              like_count:
                this.lists[this.keyName][this.index1]["like_count"] + 1,
              like_id: response.data["like_id"]
            }
          });
        });
    }
  }
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
#heart {
  color: red;
  padding: 6px;
}
#heart:hover {
  background-color: rgb(253, 209, 217);
  border-radius: 15px;
}
.heart-counter {
  margin-left: 4px;
  padding: 1.5px;
  color: red;
}
</style>
