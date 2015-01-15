class MongoidForums::ApplicationController < ApplicationController
  helper MongoidForums::Engine.helpers

  before_action :set_categories
  before_action :set_alerts

  before_filter :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  #delegate :allow_param?, to: :current_permission
  #helper_method :allow?

  private

  def set_alerts
    if mongoid_forums_user.present?
      @alerts = MongoidForums::Alert.where(:user_id => mongoid_forums_user.id, :read => false).desc(:updated_at).limit(25)
    end
  end

  def set_categories
    @categories = MongoidForums::Category.all
  end


  def current_permission
    @current_permission ||= MongoidForums::Permission.new(mongoid_forums_user)
  end

  def current_resource
    nil
  end


  def authorize
    if current_permission.allow? params[:controller], params[:action], current_resource
      #current_permission.permit_params! params
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

end
