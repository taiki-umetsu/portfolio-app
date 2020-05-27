document.addEventListener('turbolinks:load', () => {
  $("#edit-form").validate({
    rules : {
      "user[name]": {
        required: true
      },
      "user[email]": {
        required: true,
        email: true
      },
      "user[current_password]": {
        required: true,
        remote: {
          url:"/api/v1/users/check_password",
          type:"post",
          data: {
            "current_password": () => {
                return $('#user_password').val();
            }
          }
        }
      },
      "user[password]": {
        minlength : 6
      },
      "user[password_confirmation]": {
        equalTo: "#user_password"
      },

    },
    messages: {
      "user[name]": {
        required: "名前を入力して下さい。",
        email: true
      },
      "user[email]": {
        required: "メールアドレスを入力して下さい。",
        email: "Eメールの形式で入力して下さい。"
      },
      "user[current_password]": {
        required: "パスワードを入力して下さい。",
        remote: "パスワードが違います。"
      },
      "user[password]": {
        minlength : "6文字以上必要です。"
      },
      "user[password_confirmation]": {
        equalTo: "新パスワードと一致しません。"
      },
    }
  }),
  $("#login-form").validate({
    rules : {
      "user[email]": {
        required: true
      },
      "user[password]": {
        required: true,
        remote: {
          url:"/api/v1/users/check_password",
          type:"post",
          data: {
            "email": () => {
              return $('#user_email').val();
            },
            "password": () => {
                return $('#user_password').val();
            }
          }
        }
      },

    },
    messages: {
      "user[email]": {
        required: "メールアドレスを入力して下さい。",
        email: "Eメールの形式で入力して下さい。"
      },
      "user[password]": {
        required: "パスワードを入力して下さい。",
        remote: "パスワードが違います。"
      }
    }
  }),
  $("#signup-form").validate({
    rules : {
      "user[name]": {
        required: true
      },
      "user[email]": {
        required: true,
        email: true
      },
      "user[password]": {
        required: true,
        minlength : 6
      },
      "user[password_confirmation]": {
        required: true,
        equalTo: "#user_password"
      },

    },
    messages: {
      "user[name]": {
        required: "名前を入力して下さい。",
        email: true
      },
      "user[email]": {
        required: "メールアドレスを入力して下さい。",
        email: "Eメールの形式で入力して下さい。"
      },
      "user[password]": {
        required: "パスワードを入力して下さい。",
        minlength : "6文字以上必要です。"
      },
      "user[password_confirmation]": {
        required: "確認用パスワードを入力して下さい。",
        equalTo: "パスワードと一致しません。"
      },
    }
  })
})