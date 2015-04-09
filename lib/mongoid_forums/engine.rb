require "mongoid"
require 'devise'
require 'simple_form'

require 'kaminari'

module MongoidForums
  class Engine < ::Rails::Engine
    isolate_namespace MongoidForums

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end

    config.to_prepare do
      Decorators.register! Engine.root, Rails.root
    end

  end
end
