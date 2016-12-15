class RidesController < ApplicationController
	before_action :ensure_user_logged_in, only: [:edit, :update, :destroy, :new, :create]
	before_action :ensure_correct_user, only: [:edit, :update, :destroy]
	
    def index
		order_param = (params[:order] || :Date).to_sym
		ordering = case order_param
			   when :Date
			       :date
			   when :Service
			       :service_id
			   end
		@rides = Ride.order(ordering)
    end
    
    def show
    	@ride = Ride.find(params[:id])
    end
    
    def create
    	@service = Service.find(params[:service_id])
    	@ride = @service.rides.build(ride_params)
    	@ride.user = current_user
    	if @ride.save
    		flash[:success] = "Ride created"
    		redirect_to @ride
    	else
    		flash.now[:danger] = "Unable to create ride"
    		render "new"
    	end
    end
    
    def edit
    	@ride = Ride.find(params[:id])
    	@service = @ride.service
    	flash[:success] = "Editted ride successfully"
    	
    	rescue
    		flash[:danger] = "Unable to find ride"
    		redirect_to root_path
    end
    
    def update
    	@ride = Ride.find(params[:id])
		if @ride.update(ride_params)
    		flash[:success] = "Ride updated successfully"
    		redirect_to @ride
    	else
    		flash.now[:danger] = "Unable to update ride."
    		render 'edit'
    	end
		
		rescue
		    flash[:danger] = "No ride information submitted"
		    redirect_to root_path
    end
    
    def destroy
    	Ride.find(params[:id]).delete
    	flash[:success] = "Deleted ride"

    	rescue
    		flash[:danger] = "Cannot delete ride"
    		redirect_to root_path
    end
    
    def ride_params
    	params.require(:ride).permit(:user, :service, :date, :leave_time, :return_time, :number_of_seats, :seats_available, :meeting_location, :vehicle)
	end
	
	def ensure_user_logged_in
	  unless current_user
	    flash[:warning] = 'Not logged in'
	    redirect_to login_path
	  end
	end
	
	def ensure_correct_user
		@ride = Ride.find(params[:id])
		unless current_user?(@ride.user)
			flash[:danger] = "Unable to edit ride"
		    redirect_to root_path
		end
	  
		rescue
	    	flash[:danger] = "Unable to find ride"
	    	redirect_to root_path
	end
	
end