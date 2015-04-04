require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class Admin::ForumsController < BaseController
      before_action :set_forum, only: [:add_group, :remove_group]

      def index
        @forums = Forum.all
      end

      def new
        @forum = Forum.new
      end

      def create
        if @forum = Forum.create(name: params[:forum][:name], category: params[:forum][:category])
          flash[:notice] = "Category created successfully"
          redirect_to @forum
        else
          flash.now.alert = "Category could not be created"
          render :action => "new"
        end
      end

      def show
        @forum = Forum.find(params[:id])
        @groups = Group.all.where(moderator: true).select{ |group| !@forum.moderator_groups.include?(group) }
      end

      def edit
        @forum = Forum.find(params[:id])
      end

      def update
        @forum = Forum.find(params[:id])
        if @forum.update(forum_params)
          flash[:notice] = "Forum updated successfully"
          redirect_to @forum
        else
          flash.now.alert = "Forum could not be updated"
          render :action => "edit"
        end
      end

      def destroy
        @forum = Forum.find(params[:id])
        if @forum.destroy
          flash[:notice] = "Forum destroyed successfully"
          redirect_to admin_forums_path
        else
          flash.now.alert = "Forum could not be destroyed"
          render :action => "index"
        end
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_group
        group = Group.find(params[:group][:id])
        @forum.moderator_groups << group
        @forum.save

        redirect_to admin_forum_path(@forum)
      end

      def remove_group
        group = Group.find(params[:group][:id])
        @forum.moderator_groups.delete(group)
        @forum.save

        redirect_to admin_forum_path(@forum)
      end
      #########################################################

      private

      def forum_params
        params.require(:forum).permit(:name, :category)
      end

      def set_forum
        @forum = Forum.find(params[:forum_id])
      end
    end
  end
end
