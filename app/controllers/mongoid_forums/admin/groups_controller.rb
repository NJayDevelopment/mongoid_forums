require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class Admin::GroupsController < ApplicationController

    before_action :set_group, except: [:index, :new, :create]

    def index
      @groups = Group.all
    end

    def new
      @group = Group.new
    end

    def create
      if @group = Forum.create(group_params)
        flash[:notice] = "Group created successfully"
        redirect_to @group
      else
        flash.now.alert = "Group could not be created"
        render :action => "new"
      end
    end

    def edit
    end

    def update
    end

    def show
    end

    def destroy
      @group.destroy
    end

    ### Temporary Methods - Try Not To Cringe Too Much <3 ###
    def add_member
      user = User.find(params.require(:user_id))

      group.members << user.id
      group.save
    end

    def remove_member
      group = Group.find(params.require(:group_id))
      user = User.find(params.require(:user_id))

      group.members.delete(user.id)
      group.save
    end
    #########################################################
  end

  private

  def group_params
    params.require(:group).permit(:name, :members)
  end

  def set_group
    @group = Group.find(params.require(:group_id))
  end
end
