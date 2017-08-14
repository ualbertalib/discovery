class ProfilesController < ApplicationController
	$units = {:access => "Access Services", :augustana => "Augustana Library", :bib => "Bibliographic Services", :saint => "Bibliothèque Saint-Jean",  
              	:business => "Business Library", :collections => "Collection Strategies", :digital => "Digital Initiatives", 
              	:education => "Education & Physical Education Library", :external => "External Relations", :facilities => "Facilities", 
              	:health => "Health Sciences Library", :humanities => "Humanities & Social Sciences / Law Libraries", 
              	:its => "Information Technology Services", :hr => "Learning Services / Library Human Resources", 
              	:science => "Science & Technology Library", :special => "Special Collections & Archives", 
              	:archives => "University of Alberta Archives"}
    $buildings = {:augustana => "Augustana Campus Library", :bard => "Book & Record Dep (BARD)", :cameron => "Cameron Library", 
    				:saintjean => "Campus Saint-Jean", :coutts => "Coutts Library", :scott => "JW Scott Library", 
    				:rutherford => "Rutherford North", :rutherfords => "Rutherford South", :bpsc=> "Bruce Peel Special Collections Library", 
    				:winspear => "Winspear Library", :stjosephs => "St. Joseph's Library", :law => "J.A. Weir Law Library"}
	def index
		path = request.url
    	if path.include? "unit"
    		@unit = params[:unit]
			@unitname = $units[params[:unit].to_sym]
			@profiles = Profile.where("unit=?", params[:unit])
		elsif path.include? "building"
    		@building = params[:building]
			@buildingname = $buildings[params[:building].to_sym]
			@profiles = Profile.where("campus_address=?", params[:building])
		else
    		@profiles = Profile.all.order(:first_name)
    	end
    	respond_to do |format|
    		format.html
    		format.csv { send_data @profiles.to_csv }
  		end
  	end
	
	def show	
			@profile = Profile.friendly.find(params[:id])
	end


	def new
		@profile = Profile.new
	end

	def edit
		@profile = Profile.friendly.find(params[:id])
	end

	def create
  		@profile = Profile.new(profile_params)
 
  		@profile.save
  		redirect_to @profile
	end

	def update
  		@profile = Profile.friendly.find(params[:id])
 
		if @profile.update(profile_params)
			redirect_to @profile
		else
    		render 'edit'
  		end
	end

	def destroy
  		@profile = Profile.friendly.find(params[:id])
  		@profile.destroy
 
  		redirect_to profiles_path
	end

	def units
		@unit = params[:id]
		@unitname = $units[params[:id].to_sym]
		@profiles = Profile.where("unit=?", params[:id])
	end

	private
	
	def profile_params
		params.require(:profile).permit(:first_name,:last_name, :job_title, :unit, :email, :phone, :campus_address, :expertise, :introduction, :publications, :staff_since, :liason, :links, :orcid, :committees, :personal_interests, :opt_in)
	end
end
