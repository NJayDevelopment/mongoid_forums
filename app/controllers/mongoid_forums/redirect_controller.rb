require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class RedirectController < ApplicationController

    def forum
        return redirect_to forum_path(params[:forum_id])
    end

    def topic
        return redirect_to topic_path(params[:topic_id])
    end

    def posts
        post = Post.find(params[:post_id])
        return redirect_to root_path, :notice => "Post does not exist" if post.topic == nil
        x = 0

        posts = post.topic.posts

        posts.each_with_index do |p, i|
            x = i
            break if p.id == post.id
        end
        return redirect_to topic_url(post.topic, :page => (x / MongoidForums.per_page) + 1) + "#" + post.id.to_s
    end

    def subscriptions
        return redirect_to my_subscriptions_path
    end

  end
end
