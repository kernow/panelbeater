$:.unshift File.join( File.dirname(File.dirname(__FILE__)), 'lib' )
 
require 'rubygems'

require 'cpanel_api'
 
require 'test/unit'
require 'shoulda'
require 'fakeweb'
# require "rr"
 
class Test::Unit::TestCase
  
  # we don't want any connections to the outside world
  FakeWeb.allow_net_connect = false
  
  # include RR::Adapters::TestUnit
  
  # def response(name)
  #   Pepper::Stanzas::Epp.parse File.read( File.join(File.dirname(__FILE__),"fixtures", "#{name}.xml") )
  # end
  
  def fixture(name)
    File.read( File.join(File.dirname(__FILE__),"fixtures", "#{name}.json") )
  end
end