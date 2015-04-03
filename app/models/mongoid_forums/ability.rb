module MongoidForums
  class Ability
    include CanCan::Ability
      class_attribute :abilities
      self.abilities = Set.new

      # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
      # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
      # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
      # and therefore should be easy to test in isolation.
      def self.register_ability(ability)
        self.abilities.add(ability)
      end

      def self.remove_ability(ability)
        self.abilities.delete(ability)
      end

      def initialize(user)
        user ||= MongoidForums.user_class.new

        can :read, MongoidForums::Category do |category|
          user.can_read_mongoid_forums_category?(category)
        end

        can :read, MongoidForums::Topic do |topic|
          user.can_read_mongoid_forums_forum?(topic.forum) && user.can_read_mongoid_forums_topic?(topic)
        end

        if user.can_read_mongoid_forums_forums?
          can :read, MongoidForums::Forum do |forum|
            user.can_read_mongoid_forums_category?(forum.category) && user.can_read_mongoid_forums_forum?(forum)
          end
        end

        can :create_topic, MongoidForums::Forum do |forum|
          can?(:read, forum) && user.can_create_mongoid_forums_topics?(forum)
        end

        can :reply, MongoidForums::Topic do |topic|
          can?(:read, topic.forum) && user.can_reply_to_mongoid_forums_topic?(topic)
        end

        can :edit_post, MongoidForums::Forum do |forum|
          user.can_edit_mongoid_forums_posts?(forum)
        end

        can :destroy_post, MongoidForums::Forum do |forum|
          user.can_destroy_mongoid_forums_posts?(forum)
        end

        can :moderate, MongoidForums::Forum do |forum|
          user.can_moderate_mongoid_forums_forum?(forum) || user.mongoid_forums_admin?
        end

        #include any abilities registered by extensions, etc.
        Ability.abilities.each do |clazz|
          ability = clazz.send(:new, user)
          @rules = rules + ability.send(:rules)
        end

    end

  end
end
