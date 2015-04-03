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
        if @group = Group.create(params.require(:group).permit(:name, :members))
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
      end

      def show
        @group = Group.find(params[:id])
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
  end
end
