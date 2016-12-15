class ServicesController < ApplicationController
    before_action :ensure_user_logged_in, only: [:edit, :update, :destroy, :new, :create]
	before_action :ensure_correct_user, only: [:edit, :update]
    
    def index
        order_param = (params[:order] || :Day).to_sym
        case order_param
        when :Day
          @service = Service.all.sort_by{ |service| Service::Ordered_days[service.day_of_week] || -1 }
        when :Time
          @service = Service.order(:start_time)
        end
    end
    
    def show
        @service = Service.find(params[:id])
        
        rescue
            flash[:danger] = "Unable to find service"
            redirect_to service_path
    end
    
    def new
        @service = Service.new
    end
    
    def edit
        @service = Service.find(params[:id])
        rescue
            flash[:danger] = "Unable to edit user"
            redirect_to service_path
    end
    
    def create
        @service = Service.new(params[:id])
        @user = current_user
        if @service.save
            flash[:success] = "Service created"
            redirect_to @service
        else
            flash.now[:danger] = "Unable to create service"
            render "new"
        end
    end
    
    def update
        @service = Service.find(params[:id])
        if params[:click].present?
            flash[:success] = "You are riding"
            current_user.service = @service
            current_user.save
            redirect_to @service
        else
            if @service.update(service_params)
                flash[:success] = "Successfully updated service"
                redirect_to @service
            else
                flash.now[:danger] = "Unable to find service"
                render 'edit'
            end
        end
        
        rescue
            flash[:danger] = "No ride information submitted"
            redirect_to root_path
    end
    
    def destroy
        Service.find(params[:id]).delete
        flash[:success] = "Deleted service"
        redirect_to root_path
    end
    
    private
    
    def service_params
        params.require(:service).permit(:church, :day_of_week, :start_time, :finish_time, :location, :rides)
    end
    
    def ensure_correct_user
        @service = Service.find(params[:id])
        unless current_user?(@service.ride.user)
            flash[:danger] = "Cannot edit service"
            redirect_to root_path
        end
        
        rescue
            flash[:danger] = "Unable to find service"
            redirect_to users_path
    end
    
    def ensure_user_logged_in
        unless current_user
            flash[:warning] = "Not logged in"
            redirect_to login_path
        end
    end
    
end