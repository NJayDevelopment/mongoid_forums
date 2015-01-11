require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class Admin::ForumsController < BaseController
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

      def edit
      end

      def update
      end

      def destroy
      end

      private

      def category_params
        params.require(:forum).permit(:name, :category)
      end
    end
  end
end
