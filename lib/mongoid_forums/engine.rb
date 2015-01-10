require "mongoid"
require 'devise'

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums
  end
end
