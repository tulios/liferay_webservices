module LiferayWebservices
  class ServiceObject
    
    attr_reader :client, :attr
                                     
    def initialize client, method, &block
      @client = client
      @original_result = @client.send(method, &block)
      @doc = Nokogiri::XML @original_result.to_xml
      @elements = @doc.xpath("//multiRef")[0].elements
        
      @attr = {}
      @elements.each do |element|
        href = element.attributes["href"]
        if href and href.value
          id = href.value.gsub("#", '')
          @attr[element.name.underscore] = find_value(id)
        end
      end
    end
    
    def method_missing(symbol, *args)
      method = symbol.to_s
      return @attr[method]
    end
         
    private
    
    def find_value id
      @doc.xpath("//multiRef").each_with_index do |multiref, index|
        next if index == 0                        
        attr_id = multiref.attributes["id"]
        if attr_id and attr_id.value
          return multiref.children.to_soap_value if attr_id.value == id
        end
      end
    end
    
  end
end