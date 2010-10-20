module LiferayWebservices
  class ServiceObject
    
    attr_reader :client, :original_result, :doc, :elements, :attr
                                     
    def initialize client, method, &block
      @client = client
      @original_result = @client.send(method, &block)
      @doc = Nokogiri::XML @original_result.to_xml
      @elements = @doc.xpath("//multiRef")[0].elements
        
      @attr = {}
      @elements.each {|element| @attr[element.name.underscore] = find_value(element)}
    end
    
    def method_missing(symbol, *args)
      @attr[symbol.to_s]
    end
         
    private
    
    def find_value element
      href = element.attributes["href"]
      value_not_nil?(href) ? find_href_value(href) : element.children.to_soap_value
    end
    
    def find_href_value href
      id = href.value.gsub("#", '')
      @doc.xpath("//multiRef").each_with_index do |multiref, index|
        next if index == 0                        
        attr_id = multiref.attributes["id"]
        return multiref.children.to_soap_value if value_not_nil?(attr_id) and attr_id.value == id
      end
    end
    
    def value_not_nil? obj
      obj and obj.value
    end
    
  end
end