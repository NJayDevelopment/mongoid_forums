require "mongoid"
require 'devise'
require 'simple_form'
require 'kaminari'

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums
  end
end
