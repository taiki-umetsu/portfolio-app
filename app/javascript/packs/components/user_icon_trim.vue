<template>
  <div>
    <div class="alert flash-message fixed-top" :class="alertColor" v-show="flash">{{ flash }}</div>
    <div class="icon" @click="imageUploadField">
      <div class="fillter"></div>
      <i class="fas fa-camera-retro fa-2x"></i>
      <img v-bind:src="icon" class="icon-img" />
    </div>
    <transition name="slide-fade">
      <div class="upload-field" v-show="uploadField">
        <div class="trim-field container">
          <div class="row">
            <div class="col-10 offset-1 col-md-6 offset-md-3 responsive-wrapper">
              <div class="items-wrapper">
                <transition name="slide-fade">
                  <i class="fas fa-times-circle fa-2x" @click="removeField"></i>
                </transition>
                <croppa
                  v-model="croppa"
                  class="crop-field"
                  :width="300"
                  :height="300"
                  placeholder="ドラッグ&ドロップまたはクリック "
                  :placeholder-font-size="16"
                  :image-border-radius="400"
                  @init="onInit"
                  prevent-white-space
                  :accept="'image/*'"
                  :remove-button-color="'gray'"
                  :file-size-limit="2097152"
                  @file-size-exceed="onFileSizeExceed"
                ></croppa>
                <ul class="update-btn">
                  <li class="gif">
                    <img src="../../../assets/images/trim.gif" class="trim-gif" />
                  </li>
                  <li>
                    <div class="btn btn-primary" @click="uploadCroppedImage">アップデート</div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import axios from "axios";
import { mapState } from "vuex";
import { mapActions } from "vuex";
export default {
  props: {
    userId: Number,
    baseUrl: String
  },
  data() {
    return {
      croppa: null,
      uploadField: "",
      path: ""
    };
  },
  computed: {
    ...mapState(["flash", "alertColor"]),
    icon() {
      return this.path
        ? this.path
        : require("../../../assets/images/default_icon.png");
    }
  },
  mounted() {
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
    axios
      .get(`/api/v1/users/${this.userId}/image`)
      .then(response => (this.path = response.data));
  },
  methods: {
    ...mapActions(["pushFlash"]),
    onFileSizeExceed(file) {
      alert("ファイルは2MB以下でアップロードして下さい。");
    },
    uploadCroppedImage() {
      if (this.croppa.chosenFile == null) {
        this.pushFlash({
          flash: "画像を選択してください",
          alertColor: "alert-danger"
        });
      } else {
        this.croppa.generateBlob(
          blob => {
            const data = new FormData();
            data.append("image", blob, "image.png");
            axios
              .patch(`/api/v1/users/${this.userId}`, data, {
                headers: { "content-type": "multipart/form-data" }
              })
              .then(response => {
                this.path = response.data;
                this.pushFlash({
                  flash: "アイコン画像をアップデートしました！",
                  alertColor: "alert-success"
                });
              })
              .catch(function(error) {
                console.log(error);
              });
          },
          "image/png",
          0.8
        ), // 80% compressed png file
          (this.uploadField = false);
      }
    },
    imageUploadField() {
      this.uploadField = true;
    },
    removeField() {
      this.uploadField = false;
    },
    /* for circle image */
    onInit() {
      this.croppa.addClipPlugin(function(ctx, x, y, w, h) {
        /*
         * ctx: canvas context
         * x: start point (top-left corner) x coordination
         * y: start point (top-left corner) y coordination
         * w: croppa width
         * h: croppa height
         */
        console.log(x, y, w, h);
        ctx.beginPath();
        ctx.arc(x + w / 2, y + h / 2, w / 2, 0, 2 * Math.PI, true);
        ctx.closePath();
      });
    }
  }
};
</script>

<style scoped>
.trim-field {
  margin-top: 20px;
}
.responsive-wrapper {
  padding: 0;
}
.content-field {
  width: 100%;
  margin-left: 0;
}
.items-wrapper {
  width: 300px;
  margin: 0 auto;
}
li {
  float: left;
  list-style: none;
  text-align: center;
}
.gif {
  margin-left: -30px;
}
.icon {
  width: 80px;
  height: 80px;
  position: relative;
}
.icon-img {
  width: 80px;
  height: 80px;
  border-radius: 80px;
  position: absolute;
}
.fillter {
  margin-top: -0.8px;
  margin-left: -0.8px;
  width: 80.8px;
  height: 80.8px;
  border-radius: 80.8px;
  border: solid 2px rgb(100, 100, 100);
  background-color: rgba(150, 150, 150, 0.3);
  z-index: 2;
  position: absolute;
}
.fa-camera-retro {
  color: rgb(200, 200, 200);
  position: absolute;
  left: 22.5px;
  top: 22.5px;
  z-index: 3;
}
.fa-times-circle {
  color: white;
}
.upload-field {
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
.crop-field {
  background-color: rgb(255, 255, 255);
  border-radius: 300px;
  margin-top: 10px;
}
.update-btn {
  width: 100%;
}
.btn {
  margin: 20px 0 0 60px;
  width: 150px;
}
.trim-gif {
  width: 80px;
  height: 80px;
  border-radius: 80px;
}
/* animation */
.slide-fade-enter-active {
  transition: all 0.5s ease;
}
.slide-fade-leave-active {
  transition: all 0.2s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateY(-300px);
  opacity: 0;
}
.sandbox {
  background-color: rgba(73, 73, 73, 0.5);
  width: 80px;
  height: 80px;
}
</style>
