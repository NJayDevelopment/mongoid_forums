require 'cancan'

class MongoidForums::ApplicationController < ApplicationController
  helper MongoidForums::Engine.helpers

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, :alert => t("mongoid.access_denied")
  end

  def current_ability
    MongoidForums::Ability.new(mongoid_forums_user)
  end

  before_action :set_categories
  before_action :set_alerts

  private

  def set_alerts
    if mongoid_forums_user.present?
      @alerts = MongoidForums::Alert.where(:user_id => mongoid_forums_user.id, :read => false).desc(:updated_at).limit(25)
    end
  end

  def set_categories
    @categories = MongoidForums::Category.asc(:position)
  end

    def authenticate_mongoid_forums_user
    if !mongoid_forums_user
      session["user_return_to"] = request.fullpath
      flash.alert = "You must be signed in"
      devise_route = "new_#{MongoidForums.user_class.to_s.underscore}_session_path"
      sign_in_path = MongoidForums.sign_in_path ||
        (main_app.respond_to?(devise_route) && main_app.send(devise_route)) ||
        (main_app.respond_to?(:sign_in_path) && main_app.send(:sign_in_path))
      if sign_in_path
        redirect_to sign_in_path
      else
        raise "MongoidForums could not determine the sign in path for your application. Please do one of these things:
1) Define sign_in_path in the config/routes.rb of your application like this:
or; 2) Set MongoidForums.sign_in_path to a String value that represents the location of your sign in form, such as '/users/sign_in'."
      end
    end
  end

  def mongoid_forums_admin?
    mongoid_forums_user && mongoid_forums_user.mongoid_forums_admin?
  end
  helper_method :mongoid_forums_admin?

  def mongoid_forums_admin_or_moderator?(forum)
    mongoid_forums_user && (mongoid_forums_user.mongoid_forums_admin? || forum.moderator?(mongoid_forums_user))
  end
  helper_method :mongoid_forums_admin_or_moderator?

end
