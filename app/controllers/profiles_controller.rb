class ProfilesController < ApplicationController
	http_basic_authenticate_with name: "ualibraries", password: "discoverthi5", except: [:index, :show]
	
	def index
    	@profiles = Profile.all.order(:first_name)
  	end
	
	def show
    	@profile = Profile.find(params[:id])
	end

	def new
		@profile = Profile.new
	end

	def edit
		@profile = Profile.find(params[:id])
	end

	def create
  		@profile = Profile.new(profile_params)
 
  		@profile.save
  		redirect_to @profile
	end

	def update
  		@profile = Profile.find(params[:id])
 
		if @profile.update(profile_params)
			redirect_to @profile
		else
    		render 'edit'
  		end
	end

	def destroy
  		@profile = Profile.find(params[:id])
  		@profile.destroy
 
  		redirect_to profiles_path
	end

	private
	
	def profile_params
		params.require(:profile).permit(:first_name,:last_name, :job_title, :unit, :email, :phone, :campus_address, :expertise, :introduction, :publications, :staff_since, :links, :orcid, :committees, :personal_interests, :opt_in)
	end
end
