require 'liferay_webservices'

describe LiferayWebservices do
  
  before(:each) do
    LiferayWebservices.init :wsdl => true
  end
       
  context 'about the configuration file' do
    
    it 'should load the config file' do
      LiferayWebservices.config.should_not be_nil
    end                                    
    
    it 'should load a certain service name' do
      LiferayWebservices.service_name(:user).should == "Portal_UserService"
    end
    
  end
                       
  it 'should instanciate a new service' do
    client = LiferayWebservices.new_client :user
    client.should_not be_nil
    client.should respond_to :get_user_by_id
  end

end