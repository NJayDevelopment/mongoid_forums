require "mongoid"
require 'devise'
require 'simple_form'

require 'kaminari'

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums

    config.to_prepare do
      MongoidForums.decorate_user_class! if MongoidForums.user_class
    end
  end
end
