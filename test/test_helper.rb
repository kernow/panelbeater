$:.unshift File.join( File.dirname(File.dirname(__FILE__)), 'lib' )
 
require 'rubygems'

require 'panelbeater'
 
require 'test/unit'
require 'shoulda'
require 'webmock'
require 'webmock/test_unit'

class Test::Unit::TestCase
  
  include WebMock
  
  # we don't want any connections to the outside world
  WebMock.disable_net_connect!
  
  def fixture(name)
    File.read( File.join(File.dirname(__FILE__),"fixtures", "#{name}.json") )
  end
end