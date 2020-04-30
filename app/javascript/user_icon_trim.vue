<template>
  <div class="contents">
    <transition name="slide-fade">
      <div class="upload-field" v-show="uploadField">
        <transition name="slide-fade">
          <i class="fas fa-times-circle fa-2x" @click="removeField"></i>
        </transition>
        <croppa v-model="croppa" class="crop-field"
                :width="400"
                :height="400"
                placeholder="ドラッグ&ドロップまたはクリック "
                :placeholder-font-size="20"
        ></croppa>
        <div class="update-btn">
          <button class="btn btn-primary" @click="uploadCroppedImage">update</button>
        </div>
      </div>
    </transition>

    <div class="user-icon" @click="imageUploadField">
      <div class="fillter"></div>
      <i class="fas fa-camera-retro fa-2x"></i>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      croppa: {},
      dataUrl: '',
      uploadField: ''
    }
    
  },
  methods: {
    uploadCroppedImage() {
      this.croppa.generateBlob((blob) => {
      // write code to upload the cropped image file (a file is a blob)
      }, 'image/jpeg', 0.8) // 80% compressed jpeg file
    },
    imageUploadField(){
      this.uploadField = true;
    },
    removeField(){
      this.uploadField = false;
    }
  }
}
</script>

<style scoped>
  .user-icon {
    color: rgba(187, 185, 185, 0.287);
    width: 80px;
    height: 80px;
    border-radius: 80px;
    background-image: url("../../default_icon.png");
    position: relative;
  } 
  .fillter{
    margin-top:-0.8px;
    margin-left:-0.8px;
    width: 80.8px;
    height: 80.8px;
    border-radius: 80.8px;
    border: solid 2px rgb(100, 100, 100);
    background-color: rgba(30, 30, 30, 0.3);
  }
  .fa-times-circle {
    position: absolute;
    right: 2%;
    top: 1%;
    color: white;
  }
  .fa-camera-retro{
    color:  rgb(200, 200, 200);
    position: absolute;
    left: 22.5px;
    top: 22.5px;
  }
  .upload-field {
    background-color: rgba(73, 73, 73, 0.5);
    width:100vw; 
    height: 100%;
    position: absolute;
    left: 50%;
    right: 50%;
    top: 0;
    margin: 0% -50vw;
    z-index: 2;
  }
  .crop-field{
    background-color: rgb(255, 255, 255);
    position: absolute;
    top: 10%;
    left: 50%;
    -webkit-transform : translateX(-50%);
    transform : translateX(-50%);
  }
  .update-btn {
    position: absolute;
    width: 400px;
    top: 58%;
    left: 50%;
    -webkit-transform : translateX(-50%);
    transform : translateX(-50%);
  }
  .btn {
    margin: 0;
    position: absolute;
    right: 0;
  }
  /* animation */
  .slide-fade-enter-active {
    transition: all .5s ease;
  }
  .slide-fade-leave-active {
    transition: all .2s cubic-bezier(1.0, 0.5, 0.8, 1.0);
  }
  .slide-fade-enter, .slide-fade-leave-to{
    transform: translateY(-300px);
    opacity: 0;
  }
</style>
