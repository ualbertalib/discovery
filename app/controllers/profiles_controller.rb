class ProfilesController < ApplicationController
  $units = {:access => "Access Services", :archives => "Archives", :augustana => "Augustana Library", :bib => "Bibliographic Services",
        :saint => "Bibliothèque Saint-Jean", :business => "Business Library", :collections => "Collection Strategies", :digital => "Digital Initiatives",
                :education => "Education / Kinesiology, Sport & Recreation Library", :facilities => "Facilities", :finance => "Financial Systems & Analysis",
                :health => "Health Sciences Library", :hr => "Human Resources", :humanities => "Humanities & Social Sciences / Law Libraries",
                :its => "Information Technology Services", :admin => "Learning Services/Libraries Administration", :science => "Science & Technology Library", :special => "Special Collections",
                :press => "University of Alberta Press"}
    $buildings = {:augustana => "Augustana Campus Library", :bsj => "Bibliothèque Saint-Jean", :bpsc=> "Bruce Peel Special Collections",
            :cameron => "Cameron Library", :coutts => "Herbert T. Coutts Library ", :law => "J.A. Weir Law Library", :scott => "J.W. Scott Library",
            :rcrf => "Research & Collections Resource Facility", :press => "Ring House 2", :rutherford => "Rutherford",
            :stjosephs => "St. Joseph's Library", :winspear => "Winspear Library" }

        # You'll have to define "profilesEditPassword" in secrets.yml, or this will fail. Thanks, ansible.
  http_basic_authenticate_with name: Rails.application.secrets.profiles_edit_user, password: Rails.application.secrets.profiles_edit_password, except: [:index, :show]

  def index
    path = request.url
      if path.include? "unit"
        @unit = params[:unit]
      @unitname = $units[params[:unit].to_sym]
      @profiles = Profile.where("unit=?", params[:unit]).order(:first_name)
    elsif path.include? "building"
        @building = params[:building]
      @buildingname = $buildings[params[:building].to_sym]
      @profiles = Profile.where("campus_address=?", params[:building]).order(:first_name)
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
    @buildings = $buildings
    @units = $units
  end

  def edit
    @profile = Profile.friendly.find(params[:id])
    @buildings = $buildings
    @units = $units
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
