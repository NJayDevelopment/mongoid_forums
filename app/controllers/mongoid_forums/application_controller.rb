class MongoidForums::ApplicationController < ApplicationController
  helper MongoidForums::Engine.helpers

  before_action :set_categories
  before_action :set_alerts

  private

  def set_alerts
    if mongoid_forums_user.present?
      @alerts = MongoidForums::Alert.where(:user_id => mongoid_forums_user.id, :read => false).desc(:updated_at).limit(25)
    end
  end

  def set_categories
    @categories = MongoidForums::Category.all
  end

end
