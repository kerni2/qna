# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :mark_as_best, Answer, question: { user_id: user.id }

    can :like, Question
    cannot :like, Question, user_id: user.id
    can :unlike, Question
    cannot :unlike, Question, user_id: user.id

    can :like, Answer
    cannot :like, Answer, user_id: user.id
    can :unlike, Answer
    cannot :unlike, Answer, user_id: user.id

    can :read, Reward, user_id: user.id
  end
end
