<template>
  <div>
    <div class="alert flash-message fixed-top" 
         :class="alertColor" 
         v-show="flash">{{flash}}
    </div>
    <transition name="slide-fade">
      <div class="upload-field" v-show="show" >
        <div class="comment-form container">            
          <div class="row">
            <div class="col-10 offset-1 col-md-6 offset-md-3">
              <div>
                <transition name="slide-fade">
                  <i class="fas fa-times-circle fa-2x"
                    @click="show=!show"
                  ></i>
                </transition>
                <croppa v-model="croppa" class="crop-field"
                        :width="300"
                        :height="400"
                        placeholder="ドラッグ&ドロップまたはクリック "
                        :placeholder-font-size="20"
                        :accept="'image/*'"
                        :remove-button-color="'gray'"
                        :file-size-limit="2097152"
                        @file-size-exceed="onFileSizeExceed"
                ></croppa>
                
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
      <i class="fas fa-user-astronaut"></i>
      <i class="fas fa-plus"></i>
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
.show-create-avatar-field-btn{
  border: 0.5px solid black;
  border-radius: 10px;
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
  margin-top:80px;
}
.fa-times-circle {
  color: white;
}
.comment-form textarea{
  height:100px;
  margin-top:30px;
  border-radius: 10px;
}
.comment-form .comment-btn{
  width:100%;
  text-align: right;
}
.comment-form .btn{
  margin:0;
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
