class PermalinkController < ApplicationController

  def index
    redirect_to "https://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/5?searchdata1=#{params['id']}"
  end

end
