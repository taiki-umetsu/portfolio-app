<template>
    <transition name="slide-fade">
      <div class="upload-field" v-show="fieldKey">
        <div class="comment-form container">            
          <div class="row">
            <div class="col-6 offset-3">
              <div>
                <transition name="slide-fade">
                  <i class="fas fa-times-circle fa-2x"
                    @click="closeField"
                  ></i>
                </transition>
                <textarea id="comment" :placeholder="textAreaPlaceHolder"
                  v-model="formInputContent"
                ></textarea>
                <div class="comment-btn">
                  <button class="btn btn-primary"
                    @click="submit"
                  >{{btnText}}</button>
                </div>
              </div>
            </div>
          </div>  
        </div>
      </div>
    </transition>
</template>

<script>
import { mapState } from 'vuex'
import { mapActions } from 'vuex'

export default {
  computed: {
    ...mapState(['lists']),
    formInputContent:{
      get () {
        return this.$store.state.formInputContent
      },
      set (value) {
        this.$store.commit('updateContent', value)
      }
    },    
    fieldKey(){
      return this.lists[this.index1][this.index2][this.fieldKeyName]
    }
  },
  props: {
    index1: Number,
    index2: Number,
    fieldKeyName: String,
    btnText: String,
    textAreaPlaceHolder: String,
  },
  methods: {
    ...mapActions(['updateList', 'updateContent']),
    closeField(){
      this.updateList({
          'index1' : this.index1,
          'index2' : this.index2,
          'data': { [this.fieldKeyName] : false} 
      })
    },
    submit(){
      this.$emit('submit')
    },
  },
};
</script>

<style scoped>
.upload-field {
  background-color: rgba(73, 73, 73, 0.5);
  width:100vw; 
  height: 100%;
  position: fixed;
  left: 50%;
  right: 50%;
  top: 40px;
  margin: 0 -50vw;
  z-index: 5;
}
.fa-times-circle {
  margin-top:50px;
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
  transition: all .5s ease;
}
.slide-fade-leave-active {
  transition: all .2s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to{
  transform: translateY(-50px);
  opacity: 0;
}
</style>
