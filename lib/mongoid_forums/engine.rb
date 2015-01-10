require "mongoid"
require 'devise'
require 'simple_form'

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums
  end
end
