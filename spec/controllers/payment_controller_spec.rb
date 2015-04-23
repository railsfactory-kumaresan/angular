require 'spec_helper'

##
# Since payments stuff are not truly defined,
# we are just seeing if certain actions exists
describe PaymentsController do
  # include Devise::TestHelpers
  before(:each){
    User.delete_all
    @role = Role.find_by(:name => "Individual")
    @pricing_plan = PricingPlan.where(plan_name: "Solo").first
    @user = FactoryGirl.create(:user,:default_user,:role_id => @role.id,:authentication_token => "8982jd9sjdskd02ejskdsdoj",:business_type_id => @pricing_plan.business_type_id.to_i )
    controller.stub(:check_admin_user).and_return(@user)
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_role_level_permissions).and_return(true)    
    @controller.stub(:current_user) { @user }
  }

  describe "#merchant test" do
     it "Check merchant email is valid?" do
       get :merchant_test, :authentication_token => @user.authentication_token
       expect(assigns[:bussiness_type]).to eq @user.business_type_id
       #~ expect(assigns[:plans]).should include(@pricing_plan)
       expect(response).to be_success
       expect(response.status).to eq(200)
     end

     it "Check merchant email is invalid?" do
       @controller.stub(:current_user){nil}
       get :merchant_test, :authentication_token => @user.authentication_token
       flash[:fadeout_notice].should == "Your email is incorrect or not confirmed yet. Please update or confirm your E-mail address"
       response.should redirect_to "/users/edit"
     end
  end

  describe "#Handler" do
    it "Send valid params to cc avenenue" do
      params =  { :authentication_token => @user.authentication_token, "plan_id"=>@pricing_plan.id, "plan_action"=>"upgrade", "billing_name"=>"test Test",
                    "billing_email"=>"muthuselvam@railsfactory.org", "billing_address"=>"chennai India",
                    "billing_city"=>"Chennai", "billing_state"=>"Tamilnadu", "billing_country"=>"IN", "billing_zip"=>"600002",
                    "billing_tel"=>"9874561230", "bus_type"=>""}
      controller.instance_variable_set(:@token, "false")
      post :handler, params
      expect(TransactionDetail.all.count).to eq 1
    end
  end


  describe "#payment_notify_mail_non_subscribe" do
    business_user(PricingPlan.where(plan_name: "Solo").first.business_type_id)
    payment=PaymentsController.new
    context "" do
      subscribe_false_user(PricingPlan.where(plan_name: "Solo").first.business_type_id)
      it "check cron job" do
        payment.payment_notify_mail_non_subscribe
      end
    end
    context "" do
      sub_end_with_seven_day(PricingPlan.where(plan_name: "Solo").first.business_type_id)
      it "" do
        payment.payment_notify_mail_subscribe
      end
    end

    context "" do
      subscribe_expired_user(PricingPlan.where(plan_name: "Solo").first.business_type_id)
      it "check_subscribed_user_acc_status" do
        # payment=PaymentsController.new
        payment.check_subscribed_user_acc_status
        expect(assigns[:bitly_url]).to eq nil
      end
    end
  end


  describe "update_billing" do
    it "update billing info " do
      params = {:format => "js",:user_id => @user.id,:billing_name => "Tests test",:billing_email => @user.email,:billing_address => "Chennai welcome",:billing_city => "essss",:billing_state => "sdsdsd",:billing_country => "IN",:billing_zip => "600564",:billing_phone => "8974561230" }
      post :update_billing,params
    end
  end


  describe "send_cancel_email" do
    it "send_cancel_email " do
      params = {:message => "This is nice to see you"}
      post :send_cancel_email,params
    end
  end

#Need to done wkhtmlpath for test
  #~ describe "download_success" do
    #~ it "download_success " do
      #~ post :download_success, :format => "pdf"
    #~ end
  #~ end

  describe "#response_handler" do
    it "Get the cancel response from ccavenue" do
      #controller.stub!(:response_handler).and_return(true)
     User.delete_all
     @role = Role.find_by(:name => "Individual")
     @user = FactoryGirl.create(:user,:default_user,:role_id => @role.id,:authentication_token => "8982jd9sjdskd02ejskdsdoj",:id=> 5)
     FactoryGirl.create(:client_setting, :client_feature_settings, :user_id => @user.id, :pricing_plan_id => 2)
     FactoryGirl.create(:transaction_detail,:amount => 36000,:transaction_id => "Qwertyu23344",:profile_id=> "testuser123",
     :expiry_date => Time.now + 1.month,:order_id => 'I521306130153m',:active=>true,:action => "upgrade",
     :payment_status => 'Incomplete',:response_dec => "Test Response",:response_code => 23456,:business_type_id => 2)
     params={"encResp"=>"d90673a82ecc73408237d3eced0f426b08824a849e2a3869cf9f9687244847410b3e774e2d2a3380b687277aa8be5c9135a379eb8997ab6e0abe5a9752375c8bc4451c2a5cb20ab2a2e6eef5ce90fd445d24e84f4e3fefbb067fd283ec0683840243f6858b33a0871a81ac4f0092dba90a0a61dd9deabe668d0be0f13ff4fb4958c1317360de55e43081a2900d9396c99d0540b75ecb2c633c5491a8aaa77fda78232c109eb5508a4a826f97c5781ad9c7bcd0eeaf2c04f2bdd0e4149da8fff1a4888d93e055701f63bb6ae616d19b78de0618d79e611f787c4e4d11c3ba4a477016af82f61cf366dce0011bc6ae0e4dde7662d724f3da75db271944895ceed4681d3353059b6981baac3aa70f2403373b2027bff7d3e48f92fe1d668e06e4cbf5ffb02644c1a0b58a36a069497281bc777b2469d2e14b80fca50704dd46dbc7d6eb5ba128ba3db220bd67c1eebbc181c3ea121cbdfc5d246426c39cca2e7c0e05dfcee8200350102a9fbd7ebfa1c7adfea8244d51032b5e9ec728262cb4d339da184d2c41256d2e5e3b040ac6c404cd718012c3a8cc7ce8ff18ab59b893b9e2835e8221645cd7b333197b9e1a9a64bbebacc8f5098490bc69422bc199ea77e01cb431c072cdedaa3dff5c3ab41e649854af7451c17a64b3d5cc69cf1dd7ca6eebba9872f498e4e121433fc3b4ec762eb57403a578489cc60c56f7b3370a896fb64004a5427d3d52de6d8bad76e2facb4b95972c9f4bb72f6ca42fa8adc22dad07cd85338ccf973891b6ff8f5c74133d141b60ca1c0f31980a342a786316318cf709817c05678a4bfc1db2232c47f8c0"}
     post :response_handler, params
      expect(TransactionDetail.all.count).to eq 1
     flash.should_not be_nil
     flash[:notice].should eql("The transaction was aborted.")
     response.should redirect_to "/dashboard?status=Aborted"
    end

    it "Get the success response from ccavenue" do
      #controller.stub!(:response_handler).and_return(true)
      User.delete_all
      @role = Role.find_by(:name => "Individual")
      @user = FactoryGirl.create(:user,:default_user,:role_id => @role.id,:authentication_token => "8982jd9sjdskd02ejskdsdoj",:id=> 5)
      FactoryGirl.create(:transaction_detail,:amount => 36000,:transaction_id => "Qwertyu23344",:profile_id=> "testuser123",
                         :expiry_date => Time.now + 1.month,:order_id => 'I321806150926a',:active=>true,:action => "upgrade",
                         :payment_status => "Incomplete",:response_dec => "Test Response",:response_code => 23456,:request_plan_id => PricingPlan.where(plan_name: "Enterprise").first.business_type_id)
      FactoryGirl.create(:client_setting, :client_feature_settings,pricing_plan_id: PricingPlan.where(plan_name: "Enterprise").first.id,user_id: @user.id)
      #params= {"encResp"=>"b8834adbeff46af319f7af34b18a5a9c465033d215883b629930885bdee8ce2dc0aa5af2734e43c1a011b6cfce3a2b7fc1379d87aea83c79b31d70ac58e122fbf214fd798a0cafddd0a8aee717d27963f12bf864141d7250efdf885ef261d106ab38dacacc4b8a0b2e54b93a3fe70427289738a8139ed6288d0d8e955f196858b7cb3e6080e526230cb2b3ecc1c040719508bb26291771b4ce14d5939c7d394584b41c92ce4d8c0b65f42f820766f4af06a1b83b469f3c38443fb8711ce87f073ef177acfa74d46e54519ce103c4b1067d03e8106882b15507c79087da7d204eb378c5fd49176192839ac38e23d965b897b8a49cd9942af25c30d0afe3e2df0bb43f21082bc2b77579ab62291074514288f39f7bdbee7603db5d80740ebb7f4676bf70f9a6747dc2ffc85aea47111efe4b803a9e143f56344a51e81322ad59d3fb421527f4e93384a5ee1c4e2e59a58664503bddb5cad0a05f01b0648ea276c8a4fe2b0809bf367d6019c7ad1a23620d09e3d4c0d4c4575cf4a0a3d6c76393c9b7cff0135629f53403306a759c20360ef576bbeeb87a00decb6fe710a65d71151f3781a9a891b4c5131c2ce76665be638d39c92e24784aa7388dc79ed928ca5ba81515f499f0b9fa4c59d80db0a121cc979bafa6426d99647b3fcaf26c8b00a43d2165633dd3e5ad658fc94dff444d1a3498f377ff92085abb0410d2c80198ef8f78e8ab9f347c665e7414b9716c4ba3c49c9356f8e97454f013e97ca3831453c0dfa455e5605ba22f477185050ea364a9fed007b3eb7a64bc0177b10f60513978042cd80eb13633798850e98927b50f1c8ae4bb06497dc7a6d6e5e30a53dd03f5e0c90054861f12390340fcb0815fe6"}
      params = {"encResp"=>"8eb78fe27bea61c76ea563e5575fc03d32ae84bd71ea910623f5185ba872cc6f39279a18c7fe5f2ac82dec06a75f99cc661c3c496b6ed215f6bc3b4afa4d188d2b3775831816e6b2a875132f9222cf932adb8633f32f017f665ca724121cbb441e1a2a7d4fc5f5d20443225822d6a445ce0c9289e3df7aa05129d908af00fe0329fc5abfc82917dc0f09e4de977a748f0f093507898fb20f0decebf2ee4210dfe974487820c38b6ac73ed6628a4b96a37321b5001a0d9c41391b26c90711fedc458ae5ceb3f6880437aefd45387d69bf50387c7e7f575ef49c91ea493c0d6688cd0188fbca6561742bbc45ba5f97ca16dbdfae15650a649d3268fc9487b7f38a9fe886c2b03128b89b9854a0c1f2b5c2f0de04b522995b7400bfbf07fb807d4ae15f1eb03f0c8a0893749840eb1685d17f7f9a37789e78a21b5ac3a060b7f1d27f503442dce8975c9e0f4e1ba05518cc06da3295a8565cb8dc8a2d98843234ba897b42fc10c6e9fe2a4f9fb366b19a0034a2f17ad5da2c6cff25c00cbe53bb59463632df92641936b082e570d9b9d89e1c197979966fa24752dcbc2a2f8ea4175e87b53fb33ad8d65ca8203f472293104ea9ba57a37ae478f09329b1eac34d345d13913a23c42a79b22fe1fa0a3d64de67ecbf11c3dfba2fdc2d503a14445af4099ee66d26d3cd23758be06512d8f8a1b436e9614dd9a5ee000be6b7c0f4ba6cbf72b68860031e81679e0378e3415a5a28190477f5143ed3f5264733cd3572c75c3ed6946bbd28a7579e3d3ae9264ea780ad6d987df5e85e389e1769b227a499431b9db2c1e920195350ade6033b96206bfc5fc2f32c1a269f4df876a390c6b40089b7dfc820df392702378b3580ec02"}
      post :response_handler, params
      expect(TransactionDetail.all.count).to eq 1
    end
  end

  # describe "#post_to_zaakpay" do
  #   it "must have action named post_to_zaakpay" do
  #     TransactionDetail.delete_all
  #     post :post_to_zaakpay
  #     expect(response).to be_success
  #     expect(response.status).to eq(200)
  #     expect(TransactionDetail.count).to eq 1
  #   end
  # end

  # describe "#z_response" do
  #   it "must have action named post_to_zaakpay" do
  #     @controller.stub(:z_response).and_return(true)
  #   end
  # end
end

def access_code(params,pricing_plan,user)
  @pricing_plan = PricingPlan.find_by_id(pricing_plan.id)
  params["merchant_id"] =  ENV["CCAVENUE_MERCHANT_ID"]
  params["order_id"] = "898sdskdjsd"
  params["amount"] = (pricing_plan.amount * 12).to_s
  params["currency"] = "INR"
  params["redirect_url"] = ENV["CCAVENUE_REDIRECT_URL"]
  params["cancel_url"] = ENV["CCAVENUE_CANCEL_URL"]
  params["language"] = "EN"
  params["billing_ name"] = user.first_name
  merchantData=""
  working_key= ENV["CCAVENUE_WOKING_KEY"] #Put in the 32 Bit Working Key provided by CCAVENUES.
  access_code= ENV["CCAVENUE_ACCESS_CODE"]   #Put in the Access Code in quotes provided by CCAVENUES.

  params.each do |key,value|
    merchantData += key+"=" + "#{value}" + "&"
  end

  #encrypted_data = Base64.encode64("#{merchantData},#{working_key}")

  crypto = Crypto.new
  encrypted_data = crypto.encrypt(merchantData,working_key)
  return encrypted_data,access_code
end

