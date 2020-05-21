<template>
  <div>
    <div class="alert flash-message fixed-top" 
         :class="alertColor" 
         v-show="flash">{{flash}}
    </div>
    <transition name="slide-fade">
      <div class="upload-field" v-show="show" >
        <div class="comment-form container">            
          <div class="row content-field">
            <div class="col-10 offset-1 col-md-6 offset-md-3 responsive-wrapper">
              <div class="items-wrapper">
                <div class="close-field-btn">
                  <transition name="slide-fade">
                    <i class="fas fa-times-circle fa-2x"
                      @click="show=!show"
                    ></i>
                  </transition>
                </div>
                <div class="image-upload-field">
                  <croppa v-model="croppa" class="crop-field"
                          :width="300"
                          :height="400"
                          placeholder="顔画像をアップロードして下さい"
                          :placeholder-font-size="18"
                          :accept="'image/*'"
                          :remove-button-color="'gray'"
                          :file-size-limit="2097152"
                          @file-size-exceed="onFileSizeExceed"
                  ></croppa>
                </div>
                <div class="comment-btn">
                  <button class="btn btn-primary"
                    @click="submit">アバター作成
                  </button>
                </div>
              </div>
            </div>
          </div>  
        </div>
      </div>
    </transition>
    <button class="show-create-avatar-field-btn" @click="show=!show">
      <h2 class="plus">+</h2>
    </button>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import { mapActions } from 'vuex'
import axios from 'axios';
export default {
  props: {
    currentUserId: Number,
    baseUrl: String 
  },
  data() {
    return {
      croppa: null,
      show: false,
    }
  },
  computed: {
    ...mapState(['lists', 'flash', 'alertColor'])
  },
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  methods:{
    ...mapActions(['updateList','pushFlash']),
    onFileSizeExceed (file) {
      this.pushFlash({
        'flash' : 'ファイルサイズ2MB以下でアップロードして下さい',
        'alertColor' : 'alert-danger'
      });
    },
    submit() {
      if(this.croppa){
        this.pushFlash({
          'flash' : '画像を選択してください',
          'alertColor' : 'alert-danger'
        });
      }else{
        this.croppa.generateBlob(
          blob => {
            const data = new FormData();
            data.append('image', blob,'image.png');
            axios.post('/api/v1/avatars', data, {
                headers: {'content-type': 'multipart/form-data'}
              })
              .then(response => (
                console.log(response)
              ))
              .catch(function (error) {
                console.log(error);
              });
          },
          'image/png',0.8
        ), // 80% compressed png file
        this.show = false;
      };
    },
  },
}
</script>

<style scoped>
.plus{
  margin:auto;
  width:40px;
  height:40px;
  color:gray;
}
.show-create-avatar-field-btn{
  border: 0.5px solid gray;
  border-radius: 10px;
  width:40px;
  height:40px;
  cursor: pointer;
  outline: none;
  padding:0;
  background-color:white;
}
.upload-field {
  background-color: rgba(73, 73, 73, 0.5);
  width:100vw; 
  height: 100%;
  position: fixed;
  left: 50%;
  right: 50%;
  top: 60px;
  margin: 0 -50vw;
  z-index: 5;
}
.comment-form{
  margin-top:20px;
  padding:0;

}
.fa-times-circle {
  color: white;
}
.crop-field{
  margin-top:20px;
  border-radius: 10px;

}
.comment-form .comment-btn{
  width:100%;
  text-align: right;
}
.comment-form .btn{
  margin:20px 0 0 0;
  width:150px;
}

.content-field{
  width:100%;
  margin-left:0;
}
.close-field-btn{
  width:100%;
}
.image-upload-field{
  width:100%;
  text-align:center;
}
.items-wrapper{
  width:300px;
  margin: 0 auto;
}

/* animation */
.slide-fade-enter-active {
  transition: all .2s ease;
}
.slide-fade-leave-active {
  transition: all .1s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to{
  transform: translateY(-10px);
  opacity: 0;
}


</style>
