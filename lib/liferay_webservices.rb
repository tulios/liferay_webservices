require 'yaml'
require 'savon'
require 'activesupport'
require 'proxy_machine'
require 'nokogiri'
require 'open-uri'

module LiferayWebservices
  
  CONFIG_FILE_PATH = 'liferay_webservices.yml'
               
  def self.init params = {:wsdl => true}
    @wsdl = params[:wsdl] ? true : false
    self.config
  end
          
  def self.config environment = "development"      
    # Rails.root.to_s                            
    path = File.expand_path("spec/resources/#{CONFIG_FILE_PATH}")
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(path).read)[environment].symbolize_keys
  end
                                                                         
  def self.service_name service
    config[:services][service.to_s]
  end
  
  def self.host
    config[:host].gsub(/\/?$/, '')
  end
  
  def self.new_client service
    @client = Savon::Client.new "#{host}/#{service_name(service)}#{@wsdl ? '?wsdl' : ''}"
  end

  def self.execute method, &block
    ServiceObject.new(@client, method, &block)
  end
  
  # def new_liferay_client service
  #   proxy_for LiferayWebservices.new_client(service), :after => {
  #     :method_missing => lambda {|client, result| ServiceObject.new(client, result)}
  #   }
  # end
  
end

require 'lib/liferay_webservices/service_object'
