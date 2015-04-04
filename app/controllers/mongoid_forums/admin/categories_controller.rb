require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class CategoriesController < BaseController
      def index
        @forums = Forum.all
      end
      
      def new
        @category = Category.new
      end

      def create
        if @category = Category.create(name: params[:category][:name])
          flash[:notice] = "Category created successfully"
          redirect_to root_path
        else
          flash.now.alert = "Category could not be created"
          render :action => "new"
        end
      end

      def edit
      end

      def update
      end

      def destroy
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
