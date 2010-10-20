require 'yaml'
require 'savon'
require 'activesupport'
require 'proxy_machine'
require 'nokogiri'
require 'open-uri'

module LiferayWebservices
                             
  CONFIG_DIR = ENV["RAILS_ENV"] ? 'config/' : '../config/'
  CONFIG_FILE_NAME = 'liferay_config.yml'
  SERVICES_FILE_NAME = 'liferay_services.yml'
                         
  # =========================================================================================================
  # ClassMethods
  # =========================================================================================================
  
  def self.included klass
    LiferayWebservices.init
  end
               
  def self.init params = {:wsdl => true}
    @wsdl = params[:wsdl] ? true : false
    
    ENV["RAILS_ENV"] = 'development' unless ENV["RAILS_ENV"]
    
    self.config
    self.services
  end
          
  def self.config environment = ENV["RAILS_ENV"]      
    path = File.expand_path("#{CONFIG_DIR}#{CONFIG_FILE_NAME}")
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(path).read)[environment].symbolize_keys
  end                                       
  
  def self.services
    path = File.expand_path("#{CONFIG_DIR}#{SERVICES_FILE_NAME}")
    @services ||= YAML.load(File.open(path).read).symbolize_keys
  end
                                                                         
  def self.host
    config[:host].gsub(/\/?$/, '')
  end
  
  def self.new_client service_name
    Savon::Client.new "#{host}/#{services[service_name]}#{@wsdl ? '?wsdl' : ''}"
  end
  
  def self.execute client, method, params
    ServiceObject.new(client, method) {|s| s.body = params }
  end
  
  # =========================================================================================================
  # InstanceMethods
  # =========================================================================================================
  
  def new_liferay_client service_name         
    client = LiferayWebservices.new_client service_name
    proxy_for client, 
      :allow_dinamic => true, 
      :avoid_original_execution => true,
      :after_all => lambda {|client, result, method, args|
        ServiceObject.new(client, method) {|s| s.body = *args }
      }
  end
  
end

require 'liferay_webservices/service_object'







































