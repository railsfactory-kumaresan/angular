require "spec_helper"

describe StaticController do
  before(:each){
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
  }
  describe "GET #about" do
    it "responds successfully with an HTTP 200 status code" do
      get :about
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "GET #help" do
    it "responds successfully with an HTTP 200 status code" do
      get :help
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end