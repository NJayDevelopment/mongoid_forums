require "mongoid"

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums
  end
end
