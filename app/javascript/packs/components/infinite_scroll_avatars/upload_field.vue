<template>
  <transition name="slide-fade">
    <div class="upload-field" v-show="fieldKey">
      <div class="comment-form container">
        <div class="row">
          <div class="col-10 offset-1 col-md-6 offset-md-3">
            <div>
              <transition name="slide-fade">
                <i class="fas fa-times-circle fa-2x" @click="closeField"></i>
              </transition>

              <textarea
                id="content-form"
                :placeholder="placeHolder"
                v-model="formInputContent"
                maxlength="40"
              ></textarea>
              <div class="comment-btn">
                <button class="btn btn-primary" @click="submit">
                  {{ btnText }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import { mapState } from "vuex";
import { mapActions } from "vuex";

export default {
  computed: {
    ...mapState(["lists"]),
    formInputContent: {
      get() {
        return this.$store.state.formInputContent;
      },
      set(value) {
        this.$store.commit("updateContent", value);
      },
    },
    fieldKey() {
      return this.lists[this.keyName][this.index1][this.fieldKeyName];
    },
    placeHolder() {
      return this.textAreaPlaceHolder + "(最大40文字)";
    },
  },
  props: {
    index1: Number,
    fieldKeyName: String,
    btnText: String,
    textAreaPlaceHolder: String,
    keyName: String,
  },
  methods: {
    ...mapActions(["updateList", "updateContent"]),
    closeField() {
      this.updateList({
        index1: this.index1,
        keyName: this.keyName,
        data: { [this.fieldKeyName]: false },
      }),
        this.updateContent("");
    },
    submit() {
      this.$emit("submit");
    },
  },
};
</script>

<style scoped>
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
.comment-form {
  margin-top: 20px;
}
.fa-times-circle {
  color: white;
}
.comment-form textarea {
  height: 100px;
  margin-top: 20px;
  border-radius: 10px;
}
.comment-form .comment-btn {
  width: 100%;
  text-align: right;
}
.comment-form .btn {
  margin: 0;
}
/* animation */
.slide-fade-enter-active {
  transition: all 0.2s ease;
}
.slide-fade-leave-active {
  transition: all 0.1s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateY(-10px);
  opacity: 0;
}
</style>
