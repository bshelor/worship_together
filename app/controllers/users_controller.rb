class UsersController < ApplicationController
    before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
    before_action :ensure_correct_user, only: [:edit, :update]
    before_action :ensure_admin, only: [:destroy]

    def index
		@users = User.all
    end

    def new
    	if current_user
    		flash[:warning] = "Already logged in"
    		redirect_to root_path
    	else
			@user = User.new
		end
    end

    def create
		@user = User.new(user_params)
		if @user.save
		    flash[:success] = "Welcome to the site, #{@user.name}"
		    redirect_to @user
		else
		    flash.now[:danger] = "Unable to create new user"
		    render 'new'
		end
    end

    def show
		@user = User.find(params[:id])
	    rescue
		flash[:danger] = "Unable to find user"
		redirect_to users_path
    end

    def edit
    	@user = User.find(params[:id])
    	rescue
    	flash[:danger] = "Unable to find user"
    	redirect_to users_path
    end
    
    def update
    	@user = User.find(params[:id])
    	if params[:ride_id].present?
    		@ride = Ride.find(params[:ride_id])
    		@user.rides << @ride
    		@ride.seats_available = @ride.seats_available - 1
    		@ride.save
    		@user.save
    		flash[:success] = "Ride claimed successfully!"
    		redirect_to @ride
    	elsif params[:church_id].present?
    		@user = current_user
    		@user.church = Church.find(params[:church_id])
    		@user.save(:validate => false)
    		flash[:success] = "Church attended"
    		redirect_to church_path(params[:church_id])
    	else
	    	if @user.update(user_params)
	    		flash[:success] = "Your profile has been modified"
	    		redirect_to @user
	    	else
	    		flash[:danger] = "Unable to update profile"
	    		render 'edit'
	    	end
	    end
	    rescue
	    	flash[:danger] = "Couldn't find user"
	    	redirect_to root_path
	end
	
	#def delete
	#	redirect_to users_path
	#end
	
	def destroy
		User.find(params[:id]).delete
		flash[:success] = "Deleted current user"
		redirect_to users_path
	end

    private

    def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def ensure_user_logged_in
	unless current_user
	    flash[:warning] = 'Not logged in'
	    redirect_to login_path
	end
    end

    def ensure_correct_user
	@user = User.find(params[:id])
	unless current_user?(@user)
	    flash[:danger] = "Cannot edit other user's profiles"
	    redirect_to root_path
	end
	    rescue
		flash[:danger] = "Unable to find user"
		redirect_to users_path
    end

    def ensure_admin
	unless current_user.admin?
	    flash[:danger] = 'Only admins allowed to delete users'
	    redirect_to root_path
	end
    end
    
end
