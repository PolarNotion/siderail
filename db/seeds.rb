puts "Creating Users."

50.times do
  user = User.create(email: Faker::Internet.email, password: '123123123')
end
