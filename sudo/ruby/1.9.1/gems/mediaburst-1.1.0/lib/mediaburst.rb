module Mediaburst end

%w( 
    mediaburst/version 
    mediaburst/api
).each do |lib|
    require File.join(File.dirname(__FILE__), lib)
end