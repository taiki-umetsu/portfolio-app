# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 60.times do |n|
#   name  = Faker::Name.name
#   email = "faker-#{n + 1}@example.com"
#   password = 'password'
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password)
# end

# relationship
users = User.all
test_user = User.find_by(email: 'test.user@example.com')
following = users[10..59]
followers = users[10..59]
following.each { |followed| test_user.follow(followed) }
followers.each { |follower| follower.follow(test_user) }

# like
likers = users[10..19]
Avatar.all.each do |avatar|
  likers.each do |liker|
    Like.create!(user_id: liker.id, avatar_id: avatar.id)
  end
end
