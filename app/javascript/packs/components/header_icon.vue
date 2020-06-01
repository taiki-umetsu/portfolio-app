<template>
  <div>
    <div @click="show = !show">
      <get-user-icon
        v-if="userId"
        :userId="userId"
        :baseUrl="baseUrl"
      ></get-user-icon>
      <i class="fas fa-bars fa-lg" v-else></i>
    </div>
    <transition name="slide-fade">
      <div id="nav-window-field" v-show="show" @click="show = !show">
        <div class="container">
          <div class="row">
            <div id="nav-window" class="col-5 col-md-2 ">
              <ul v-if="userId">
                <li><a :href="userPath">マイページ</a></li>
                <li><a href="/users/edit">設定</a></li>
                <li>
                  <a rel="nofollow" data-method="delete" href="/users/sign_out"
                    >ログアウト</a
                  >
                </li>
              </ul>
              <ul v-else>
                <li><a href="">テストログイン</a></li>
                <li><a href="/users/sign_in">ログイン</a></li>
                <li><a href="/users/sign_up">アカウント作成</a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import GetUserIcon from "./get_user_icon.vue";
export default {
  components: {
    GetUserIcon,
  },
  computed: {
    userPath() {
      return `/users/${this.userId}`;
    },
  },
  props: {
    userId: Number,
    baseUrl: String,
  },
  data() {
    return {
      show: false,
    };
  },
  methods: {},
};
</script>

<style scoped>
.fa-bars {
  color: gray;
}
#nav-window-field {
  background-color: rgba(73, 73, 73, 0.5);
  width: 100vw;
  height: 100%;
  position: fixed;
  left: 50%;
  right: 50%;
  top: 60px;
  margin: 0 -50vw;
  z-index: 5;
}
#nav-window {
  height: 100%;
  background-color: white;
  position: fixed;
  right: 0;
  text-align: right;
  padding-bottom: 20px;
}
ul {
  list-style: none;
  padding: 0;
}
li {
  margin: 20px 0;
}
.container {
  margin: 0;
  padding: 0;
}
.row {
  width: 100%;
}

/* animation */
.slide-fade-enter-active {
  transition: all 0.1s ease;
}
.slide-fade-leave-active {
  transition: all 0.1s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(10px);
  opacity: 0;
}
</style>
