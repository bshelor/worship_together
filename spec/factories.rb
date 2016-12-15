FactoryGirl.define do
    factory :user do
	sequence(:name) { |i| "User #{i}" }
	sequence(:email) { |i| "user.#{i}@example.com" }
	password 'password'
	password_confirmation 'password'

	factory :admin do
	    admin true
	end
    end

    factory :church do
		transient { num_services 1 }
	
			after(:create) do |church, evaluator|
			    create_list(:service, evaluator.num_services, church: church)
			end
		user
	    name "testing this thing"
	    web_site "www.example.com"
	    description "Some church in the middle of nowhere"
    end

    factory :service do
	church
	transient { num_rides 1 }
	day_of_week "Wednesday"
	start_time "10:00 AM"
	finish_time "12:00 PM"
	location "A certain fun place"

	after(:create) do |service, evaluator|
	    create_list(:ride, evaluator.num_rides, service: service)
	end
    end

    factory :ride do
    	user
    	service
    	date "2016/12/16"
    	leave_time "9:35 AM"
    	return_time "12:00 PM"
    	number_of_seats "4"
    	seats_available "4"
    	meeting_location "DC"
    	vehicle "4 door Hyundai"
    	
	transient { num_riders 1 }

	after(:create) do |ride, evaluator|
	    ride.users = create_list(:user, evaluator.num_riders)
	end
    end

    factory :user_ride do
      user
      ride
    end
end