document.addEventListener('turbolinks:load', () => {
  $("#edit-form").change(() => {
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
          required: "名前を入力して下さい。"
        },
        "user[email]": {
          required: "メールアドレスを入力して下さい。",
          email: "Eメールの形式で入力して下さい。"
        },
        "user[current_password]": {
          required: "パスワードを入力して下さい。",
          remote: "パスワードが一致しません。"
        },
        "user[password]": {
          minlength : "6文字以上必要です。"
        },
        "user[password_confirmation]": {
          equalTo: "新パスワードと一致しません。"
        },
      }
    })
  })
})