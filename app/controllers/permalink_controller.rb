class PermalinkController < ApplicationController

  def index
    if params['user']
      redirect_to "https://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=#{params['id']}{001}&user_id=#{params['user']}"
    else
      redirect_to "https://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=#{params['id']}{001}&user_id=WUAARCHIVE"
    end
  end

end
