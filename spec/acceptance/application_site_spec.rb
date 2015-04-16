require "open-uri"

APPLICATION_URL = "http://localhost:3000"

describe "UALDiscovery" do
  it "should at least respond " do
    open(APPLICATION_URL) do |f|
      @status = f.status
    end
    expect(@status).to eq ["200", "OK "]
  end

  it "should be up" do
    profile = Selenium::WebDriver::Firefox::Profile.new
    driver = Selenium::WebDriver.for :firefox, :profile => profile
    base_url = APPLICATION_URL
    accept_next_alert = true
    driver.manage.timeouts.implicit_wait = 30
    verification_errors = []

    driver.get(base_url + "/")
    expect(driver.title).to eq "University of Alberta Libraries"
  end
end
