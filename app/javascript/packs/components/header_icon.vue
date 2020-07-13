<template>
  <div>
    <div @click="show = !show">
      <get-user-icon v-if="userId" :userId="userId" :baseUrl="baseUrl"></get-user-icon>
      <i class="fas fa-bars fa-lg" v-else></i>
    </div>
    <transition name="slide-fade">
      <div id="nav-window-field" v-show="show" @click="show = !show">
        <div class="container">
          <div class="row">
            <div id="nav-window" class="col-5 col-md-2">
              <ul v-if="userId">
                <li>
                  <a :href="userPath">マイページ</a>
                </li>
                <li>
                  <a href="/users/edit">設定</a>
                </li>
                <li>
                  <a href="/users">ユーザー一覧</a>
                </li>
                <li>
                  <a rel="nofollow" data-method="delete" href="/users/sign_out">ログアウト</a>
                </li>
                <li>
                  <a href="https://poly.google.com/view/dLHpzNdygsg">引用</a>
                </li>
              </ul>
              <ul v-else>
                <li>
                  <a href="/users/sign_in">ログイン</a>
                </li>
                <li>
                  <a href="/users/sign_up">新規作成</a>
                </li>
                <li>
                  <a href="https://poly.google.com/view/dLHpzNdygsg">引用</a>
                </li>
              </ul>
              <div class="line-bot">
                <p>↓ LINE BOT</p>
                <img src="../../../assets/images/line_bot_qr.png" id="line-bot-qr" />
              </div>
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
    GetUserIcon
  },
  computed: {
    userPath() {
      return `/users/${this.userId}`;
    }
  },
  props: {
    userId: Number,
    baseUrl: String
  },
  data() {
    return {
      show: false
    };
  },
  methods: {}
};
</script>

<style scoped>
.fa-bars {
  color: white;
  margin-top: 7px;
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
  text-align: center;
  padding-bottom: 20px;
}
ul {
  list-style: none;
  padding: 0;
  margin-left: auto;
  margin-right: auto;
  text-align: left;
  width: 100px;
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
#line-bot-qr {
  width: 100px;
  height: 100px;
}
.line-bot {
  margin-top: 350px;
  text-align: center;
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
