puts "Creating Users."

User.create(
  first_name: "Morgan",
  last_name: "Lopes",
  email: "morgan@polarnotion.com",
  password: '123123123',
  is_admin: true
)

50.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123123123'
  )
end
