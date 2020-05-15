<template>
  <div>

    <div>
      <div class="inline" id="comments">
        <div v-if="currentUserId == false">
          <a href="/users/sign_in">
            <i class="far fa-comment" id="avatar-comment"></i>
          </a>
        </div>
        <div v-else>
          <div v-if="item['comment_id'] == false">
            <i class="far fa-comment" id="avatar-comment" 
              @click="showUploadField(index1,index2)"
            ></i> 
          </div>
          <div v-else>
            <i class="fas fa-comment" id="avatar-comment" 
              @click="showUploadField(index1,index2)"
            ></i> 
          </div>
        </div>
      </div>
      <div class="comment-counter inline">
        {{item['comment_count']}}
      </div>
    </div>

    <transition name="slide-fade">
      <div class="upload-field" v-show="item['comment_field']">
        <div class="comment-form container">            
          <div class="row">
            <div class="col-6 offset-3">
              <div>
                <transition name="slide-fade">
                  <i class="fas fa-times-circle fa-2x" @click="removeUploadField(index1,index2)"></i>
                </transition>
                <textarea id="comment" v-model="commentContent" required="required" ></textarea>
                <div class="comment-btn">
                  <button class="btn btn-primary" @click="createComment(item['avatar_id'],index1,index2)">コメントする</button>
                </div>
              </div>
            </div>
          </div>  
        </div>
      </div>
    </transition>

  </div>
</template>

<script>
import axios from 'axios';
import { mapState } from 'vuex'
import { mapActions } from 'vuex'

export default {
  mounted () { 
    axios.defaults.baseURL = this.baseUrl;
    axios.defaults.headers.get["Accepts"] = "application/json";
  },
  computed: {
    ...mapState(['lists'])
  },
  props: {
    currentUserId: Number,
    item: Object,
    index1: Number,
    index2: Number,
    baseUrl: String
    
  },
  data() {
    return {
      commentContent: '',
    };
  },
  methods: {
    ...mapActions(['updateList']),
    createComment(avatar_id,index1,index2){
      this.removeUploadField(index1,index2);
      axios.post('/api/v1/comments/', { avatar_id: avatar_id, content: this.commentContent},)
        .then(response => {
          this.updateList({
              'index1' : index1,
              'index2' : index2,
              'data':{ 
                'comment_count' : this.lists[index1][index2]['comment_count'] + 1,
                'comment_id' : response.data['comment_id']
              }
          })
          document.getElementById(`iframe${index1}-${index1}`).contentWindow.location.reload();
          this.commentContent = ''
        })
    },
    showUploadField(index1,index2){
      this.updateList({
          'index1' : index1,
          'index2' : index2,
          'data':{ 'comment_field' : true }
      })
    },
    removeUploadField(index1,index2){
      this.updateList({
          'index1' : index1,
          'index2' : index2,
          'data':{ 'comment_field' : false }
      })
    },
  },
};
</script>

<style scoped>
.inline{
  float: left;
}
#commetn-field{
  margin:0;
  padding:0;
}
.comment-counter{
  color: skyblue;
  padding:1.5px;
  margin-left:4px;
}

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
  transform: translateY(-300px);
  opacity: 0;
}


</style>
