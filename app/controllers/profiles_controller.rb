class ProfilesController < ApplicationController
	
	def index
    	@profiles = Profile.all.order(:first_name)
  	end
	
	def show
    	@profile = Profile.find(params[:id])
	end

	def new
	end

	def create
  		@profile = Profile.new(profile_params)
 
  		@profile.save
  		redirect_to @profile
	end

	private

	def profile_params
		params.require(:profile).permit(:first_name,:last_name, :job_title, :unit, :email, :phone, :campus_address, :expertise, :introduction, :publications, :staff_since, :links, :orcid, :committees, :personal_interests, :opt_in)
	end
end
