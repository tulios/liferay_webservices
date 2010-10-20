module LiferayWebservices
  class ServiceObject
    
    attr_reader :client
                                     
    def initialize client, method, &block
      @client = client
      @original_result = @client.send(method, &block)
      @result = @original_result.to_hash
      @multi_ref = @result[:multi_ref]
    end
    
    def method_missing(symbol, *args)
      value = @multi_ref[0][symbol]
      return @multi_ref[get_index(value)] if hash?(value) and href?(value)
      value
    end
         
    private
    def get_index value
      value[:href].gsub("#id", '').to_i
    end
    
    def hash? value
      value and value.class == Hash
    end
    
    def href? value
      not value[:href].nil?
    end
    
  end
end