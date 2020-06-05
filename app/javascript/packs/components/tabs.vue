<template>
  <div>
    <div class="col-md-6 offset-md-3 tabs-container" :class="{ fixed: isFixed }">
      <div class="container">
        <div id="tabs" class="row d-flex align-items-center shadow-under">
          <button
            class="col-6"
            :class="{ active: collectionTab }"
            :disabled="loadingNowBoolean"
            @click="showCollectionTab()"
          >
            <i class="fas fa-user-astronaut fa-lg tab-icon"></i>
            <div v-show="loadingNow && collectionTab" class="spinner-loading"></div>
          </button>
          <button
            class="col-6"
            :class="{ active: likingTab }"
            :disabled="loadingNowBoolean"
            @click="showLikingTab();firstLoadLiking()"
          >
            <i class="fas fa-heart fa-lg tab-icon"></i>
            <div v-show="loadingNow && likingTab" class="spinner-loading"></div>
          </button>
        </div>
      </div>
    </div>

    <div class="col-12">
      <Infinite
        :base-url="baseUrl"
        :current-user-id="currentUserId"
        :api="`${apiUserShow}`"
        :key-name="'userShow'"
        v-show="collectionTab"
        ref="infiniteCollection"
      ></Infinite>
      <Infinite
        :base-url="baseUrl"
        :current-user-id="currentUserId"
        :api="`${apiUserLiking}`"
        :key-name="'userLiking'"
        v-show="likingTab"
        ref="infiniteLiking"
      ></Infinite>
    </div>
  </div>
</template>

<script>
import Infinite from "./infinite_scroll_avatars/infinite_scroll_avatars.vue";
import axios from "axios";
import { mapState } from "vuex";
import { mapActions } from "vuex";
export default {
  props: {
    currentUserId: Number,
    userId: Number,
    baseUrl: String
  },
  components: { Infinite },
  data() {
    return {
      isFixed: false,
      firstLoadCollectionTab: true,
      firstLoadLikingTab: true
    };
  },
  beforeCreate() {
    document.addEventListener("turbolinks:click", () => {
      this.resetLoadingNow();
      this.resetTab();
    });
  },
  mounted() {
    window.addEventListener("scroll", this.fixedPosition);
  },
  computed: {
    apiUserShow() {
      return `/api/v1/users/${this.userId}`;
    },
    apiUserLiking() {
      return `/api/v1/users/${this.userId}/liking`;
    },
    loadingNowBoolean() {
      return this.loadingNow == 0 ? false : true;
    },
    ...mapState(["loadingNow", "collectionTab", "likingTab"])
  },
  methods: {
    ...mapActions([
      "loading",
      "loaded",
      "showCollectionTab",
      "showLikingTab",
      "resetLoadingNow",
      "resetTab"
    ]),
    fixedPosition() {
      if (window.scrollY > 200) {
        this.isFixed = true;
      } else {
        this.isFixed = false;
      }
    },
    firstLoadLiking() {
      if (this.firstLoadLikingTab == true) {
        this.$refs.infiniteLiking.manualLoad();
        this.firstLoadLikingTab = false;
      }
    }
  }
};
</script>

<style scoped>
.tabs-container {
  padding: 0;
}
#tabs {
  text-align: center;
}
#tabs p {
  margin-bottom: 0px;
}
.fixed {
  position: fixed;
  top: 57px;
  left: 0;
  background-color: #f8f9ff;
  padding: 10px 0 0 0;
  z-index: 2;
  width: 100%;
}
.active {
  border-bottom: 1px solid black;
}
.active .tab-icon {
  color: black;
}
.tab-icon {
  color: gray;
}
.shadow-under {
  box-shadow: 0 4px 3px -3px lightgray;
}
button {
  background-color: transparent;
  border: none;
  cursor: pointer;
  outline: none;
  padding: 0;
  appearance: none;
}

.spinner-loading {
  position: absolute;
  top: 6%;
  left: 32%;
  width: 15px;
  height: 15px;
  border: 1px solid gray;
  border-right: 1px solid transparent;
  border-radius: 15px;
  animation: loading 1s linear infinite;
}
@keyframes loading {
  to {
  }
  from {
    transform: rotate(360deg);
    transform-origin: 50% 50%;
  }
}
</style>
