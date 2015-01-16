require 'rails/generators'
module MongoidForums
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option "user-class", :type => :string
      class_option "current-user-helper", :type => :string

      source_root File.expand_path("../install/templates", __FILE__)
      desc "Used to install MongoidForums"

      def determine_user_class
        # Is there a cleaner way to do this?
        if options["user-class"]
          puts "Class of item passed as argument #{options["user-class"].class}"
          @user_class = options["user-class"]
        else
          @user_class = ask("What is your user class called? [User]")
          puts "Class of item passed from prompt #{@user_class.class}"
        end

        if @user_class.blank?
          @user_class = 'User'
          puts "Class of item set when blank #{@user_class.class}"
        else
          @user_class = @user_class
          puts "Class of item set when passed #{@user_class.class}"
        end

        MongoidForums.decorate_user_class!
        puts "Decorating user class!"
      end


      def determine_current_user_helper
        if options["current-user-helper"]
          current_user_helper = options["current-user-helper"]
        else
          current_user_helper = ask("What is the current_user helper called in your app? [current_user]")
        end
        current_user_helper = :current_user if current_user_helper.blank?
        puts "Defining mongoid_forums_user method inside ApplicationController..."

        mongoid_forums_user_method = %Q{
  def mongoid_forums_user
    #{current_user_helper}
  end
  helper_method :mongoid_forums_user
}

        inject_into_file("#{Rails.root}/app/controllers/application_controller.rb",
                         mongoid_forums_user_method,
                         :after => "ActionController::Base\n")
      end

      def add_mongoid_forums_initializer
        path = "#{Rails.root}/config/initializers/mongoid_forums.rb"
        if File.exists?(path)
          puts "Skipping config/initializers/mongoid_forums.rb creation, as file already exists!"
        else
          puts "Adding mongoid_forums initializer (config/initializers/mongoid_forums.rb)..."
          template "initializer.rb", path
        end
      end

      def mount_engine
        puts "Mounting MongoidForums::Engine at \"/forums\" in config/routes.rb..."
        insert_into_file("#{Rails.root}/config/routes.rb", :after => /routes.draw.do\n/) do
          %Q{  mount MongoidForums::Engine, :at => "/forums"\n}
        end
      end

      def finished
        output = "\n\n" + ("*" * 53)
        output += %Q{\nDone! MongoidForums has been successfully installed. Yaaaaay!
Here's what happened:\n\n}

      output += step("A new file was created at config/initializers/mongoid_forums.rb
   This is where you put MongoidForums's configuration settings.\n")
        output += step("The engine was mounted in your config/routes.rb file using this line:
   mount MongoidForums::Engine, :at => \"/forums\"
   If you want to change where the forums are located, just change the \"/forums\" path at the end of this line to whatever you want.")
        output += %Q{\nAnd finally:
#{step("We told you that MongoidForums has been successfully installed and walked you through the steps.")}}
        output += "Thanks for using MongoidForums!"
        puts output
      end

      private

      def step(words)
        @step ||= 0
        @step += 1
        "#{@step}) #{words}\n"
      end

      def user_class
        @user_class
      end

    end
  end
end
