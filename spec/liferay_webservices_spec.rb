require 'liferay_webservices'

describe LiferayWebservices do
  #include LiferayWebservices
                                
  before :each do
    LiferayWebservices.init
  end     
       
  context 'about the configuration file' do
    
    it 'should load the config file' do
      LiferayWebservices.config.should_not be_nil
    end                                    
    
    it 'should load a certain service name' do
      LiferayWebservices.service_name(:user).should == "Portal_UserService"
    end
    
  end
                                                
  context 'about the client initialization' do
                       
    it 'should initializate a new service' do
      client = LiferayWebservices.new_client :user
      client.should_not be_nil
      client.should respond_to :get_user_by_id
    end
    
  end  
  
  context 'about method execution on clients' do
    
    it 'should retrieve the result' do
      LiferayWebservices.new_client :user
      user = LiferayWebservices.execute(:get_user_by_id) {|s| s.body = { :id => 10144 } }
      puts "======================\n"
      p user
      puts "\n======================"
      
      user.user_id.to_i.should == 10144
      user.greeting.should == "Welcome Test Test!"
    end
    
  end
  
end