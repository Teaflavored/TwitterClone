namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
    maker_users
    make_microposts
    make_relationships
  end
end
    def maker_users
  		admin = User.create!(name: "Example User",
  			email: "example@railstutorial.org",
        username: "teaflavored",
  			password: "foobar",
  			password_confirmation: "foobar",admin: true)
  		99.times do |n|
  			name = Faker::Name.name
  			email = "example-#{n}@railstutorial.org"
        username = "example-#{n}"
  			password = "Password"
  			User.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password)
  		end
    end
    
    def make_microposts
      users = User.all(limit: 6)
      50.times do 
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content)}
      end
    end
    
    def make_relationships
      users = User.all
      user = User.first
      followed_users = users[2..50]
      followers = users[3..40]
      followed_users.each { |followed| user.follow!(followed) }
      followers.each { |follower| follower.follow!(user) }
    end