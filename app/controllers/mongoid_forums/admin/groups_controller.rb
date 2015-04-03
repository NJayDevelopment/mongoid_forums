require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class GroupsController < BaseController

      def index
        @groups = Group.all
      end

      def new
        @group = Group.new
      end

      def create
        if @group = Group.create(params.require(:group).permit(:name, :moderator, :members))
          flash[:notice] = "Group created successfully"
          redirect_to [:admin, @group]
        else
          flash.now.alert = "Group could not be created"
          render :action => "new"
        end
      end

      def edit
        @group = Group.find(params[:id])
      end

      def update
        @group = Group.find(params[:id])
        if @group.update_attributes(params.require(:group).permit(:name, :members))
          flash[:notice] = "Group updated successfully"
          redirect_to [:admin, @group]
        else
          flash[:notice] = "Group could not be updated"
          render :action => "edit"
        end
      end

      def show
        @group = Group.find(params[:id])
        @group_members = @group.members.map {|member_id| User.find(member_id) }
        @users = User.all
      end

      def destroy
        @group = Group.find(params[:id])

        if @group.destroy
          flash[:notice] = "Group destroyed successfully"
          redirect_to admin_groups_path
        else
          flash.now.alert = "Group could not be destroyed"
          redirect_to admin_groups_path
        end
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_member
        group = Group.find(params.require(:group_id))
        user = User.find(params[:user][:id])

        group.members << user.id unless group.members.include?(user.id)
        group.save

        redirect_to admin_group_path(group)
      end

      def remove_member
        group = Group.find(params.require(:group_id))
        user = User.find(params[:user][:id])

        group.members.delete(user.id)
        group.save

        redirect_to admin_group_path(group)
      end
      #########################################################
    end

    private

    def group_params
      params.require(:group).permit(:name, :members)
    end
  end
end
