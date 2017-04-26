User.create!(name:                  'Example User',
             email:                 'example@railstutorial.org',
             password:              'foobarfoobar',
             password_confirmation: 'foobarfoobar')

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password1234'
  User.create!(name:                  name,
               email:                 email,
               password:              password,
               password_confirmation: password)
end
