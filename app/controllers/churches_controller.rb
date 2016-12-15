class ChurchesController < ApplicationController
	before_action :ensure_user_logged_in, only: [:edit, :update, :destroy, :create, :new]
	before_action :ensure_correct_user, only: [:edit]
	
    def new
		@church = Church.new
		@church.services.build
    end

    def create
		@church = Church.new(church_params)
		@church.user = current_user
		if @church.save
		    flash[:success] = "Church created"
		    redirect_to @church
		else
		    flash.now[:danger] = "Unable to create church"
		    render 'new'
		end
    end
    
    def index
    	@churches = Church.all	
    end
    
    def show
    	@church = Church.find(params[:id])
    	@user = @church.user
    rescue
    	flash[:danger] = "Unable to find church"
    	redirect_to churches_path
    end
    
    def edit
    	@church = Church.find(params[:id])
    	flash[:success] = "Successfully edited church"
    rescue
    	flash[:danger] = "Unable"
    	redirect_to churches_path
    end
    
    def destroy
    	Church.find(params[:id]).delete
		flash[:success] = "Deleted current church"
    	redirect_to churches_path
    end
    
    def update
    	@church = Church.find(params[:id])
    	if @church.update(church_params)
    		@church.save
    		flash[:success] = "Church updated successfully"
    		redirect_to @church
    	else
    		flash.now[:danger] = "Unable to update church"
    		render 'edit'
    	end
    end

    private

    def church_params
	params.require(:church).permit(:name,
				       :web_site,
				       :description,
				       :picture,
				       services_attributes: [ :day_of_week, :start_time,
							      :finish_time,
							      :location ] )
    end
    
    def ensure_user_logged_in
		unless current_user
		    flash[:warning] = 'Not logged in'
		    redirect_to login_path
		end
    end
    
    def ensure_correct_user
	@user = User.find(params[:id])
	unless current_user?(@church.user)
	    flash[:danger] = "Cannot edit other church's profiles"
	    redirect_to root_path
	end
	    rescue
		flash[:danger] = "Unable to find user"
		redirect_to churches_path
    end
    
    
end