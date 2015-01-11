module MongoidForums
  class ApplicationController < ActionController::Base
    before_action :set_categories

    before_filter :authorize

    delegate :allow?, to: :current_permission
    helper_method :allow?


    private

    def set_categories
      @categories = Category.all
    end


    def current_permission
      @current_permission ||= Permission.new(current_user)
    end

    def current_resource
      nil
    end


    def authorize
      unless current_permission.allow? params[:controller], params[:action], current_resource
        redirect_to root_path, alert: "Not authorized"
      end
    end

  end
end
