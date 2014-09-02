FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "person #{n}"}
		sequence(:email) { |n| "person_#{n}@example.com"}
		password "asdfasdf"
		password_confirmation "asdfasdf"
	
		factory :admin do
			admin true
		end
	end
end