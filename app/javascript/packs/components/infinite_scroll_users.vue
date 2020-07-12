<template>
  <div>
    <div v-for="(list, $index1) in lists" :key="$index1">
      <div v-for="(item, $index2) in list" :key="$index2">
        <a :href="userPath(item['user_id'])">
          <div class="wrapper-sm shadow" :class="setUserId(item['user_id'])">
            <div class="container">
              <div class="row d-flex align-items-center">
                <get-user-icon :userId="item['user_id']" :baseUrl="baseUrl"></get-user-icon>
                <div id="user-name">{{ item["user_name"] }}</div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
    <infinite-loading :distance="100" @infinite="infiniteHandler"></infinite-loading>
  </div>
</template>

<script>
import axios from "axios";
import InfiniteLoading from "vue-infinite-loading";
import GetUserIcon from "./get_user_icon.vue";

export default {
  components: {
    InfiniteLoading,
    GetUserIcon
  },
  props: {
    baseUrl: String,
    api: String
  },
  data() {
    return {
      users_page: 1,
      lists: []
    };
  },
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
    this.triggerInfiniteScroll;
  },
  methods: {
    infiniteHandler($state) {
      axios
        .get(this.api, {
          params: {
            users_page: this.users_page
          }
        })
        .then(response => {
          if (response.data.length) {
            this.users_page += 1;
            this.lists.push(response.data);
            $state.loaded();
          } else {
            $state.complete();
          }
        });
    },
    setUserId(id) {
      return `user${id}`;
    },
    triggerInfiniteScroll() {
      if (window.scrollY == 0) {
        scrollTo(0, 100);
      }
    },
    userPath(id) {
      return `/users/${id}`;
    }
  }
};
</script>

<style scoped>
.user-icon {
  width: 40px;
  height: 40px;
  border-radius: 40px;
}
#user-name {
  margin-left: 10px;
}
a {
  text-decoration: none;
  color: rgb(0, 0, 0);
}
a:hover {
  text-decoration: none;
}
.wrapper-sm:hover {
  background-color: rgb(240, 240, 240);
}
.wrapper-sm:active {
  background-color: rgb(240, 240, 240);
}
</style>
