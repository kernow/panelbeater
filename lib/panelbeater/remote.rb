module Panelbeater
  module Remote
    
    @@default_port = 2087
    @@default_user = 'root'
    
    def set_server(options={})
  		self.base_url = options[:url]
  		self.user     = options[:user] ||= @@default_user
  		self.api_key  = options[:api_key].gsub(/\n|\r/, '')
  		self.port     = options[:port] ||= @@default_port
  	end
    
    def connect(server, port, command, username, api_key, options={})
      http = Net::HTTP.new(server, port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Ignore invalid SSL certificates
      http.start do |http|
        req = Net::HTTP::Get.new "/json-api/#{command}#{map_options_to_url(options)}"
        req.add_field 'Authorization', "WHM #{username}:#{api_key}"
        http.request(req)
      end
    end
    
    def do_request(command, options={}, mappings=nil)
      options = key_mappings(mappings, options) unless mappings.nil?
      options = filter_options(options)
      response = connect self.base_url, self.port, command, self.user, self.api_key, options
      Panelbeater::Response.new(command, response)
    end
    
    def map_options_to_url(options={})
      '?' + options.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless options.nil?
    end
    
  end
end