require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class CategoriesController < BaseController
      before_action :set_category, only: [:add_group, :remove_group]

      def index
        @forums = Forum.asc(:position)
        @categories = Category.asc(:position)
      end

      def show
        @category = Category.find(params[:id])
        @groups = Group.  all.where(moderator: true).select{ |group| !@category.moderator_groups.include?(group) }
      end

      def new
        @category = Category.new
      end

      def create
        if @category = Category.create(category_params)
          flash[:notice] = t("mongoid_forums.admin.category.created")
          redirect_to admin_categories_path
        else
          flash.now.alert = t("mongoid_forums.admin.category.not_created")
          render :action => "new"
        end
      end

      def edit
        @category = Category.find(params[:id])
      end

      def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
          flash[:notice] = t("mongoid_forums.admin.category.updated")
          redirect_to admin_categories_path
        else
          flash[:notice] = t("mongoid_forums.admin.category.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        @category = Category.find(params[:id])
        @category.destroy
        flash[:notice] = t("mongoid_forums.admin.category.deleted")
        redirect_to admin_categories_path
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_group
        group = Group.find(params[:group][:id])
        @category.moderator_groups << group
        @category.save

        redirect_to admin_category_path(@category)
      end

      def remove_group
        group = Group.find(params[:group][:id])
        @category.moderator_groups.delete(group)
        @category.save

        redirect_to admin_category_path(@category)
      end
      #########################################################

      private

      def category_params
        params.require(:category).permit(:name, :position)
      end

      def set_category
        @category = Category.find(params[:category_id])
      end
    end
  end
end
