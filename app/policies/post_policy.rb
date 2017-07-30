class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present?
        scope.where("(posts.owner_id = ? OR posts.state = ?)", user.id, "built")
      else
        scope.where(state: "built")
      end
    end
  end

  def index?
    user.present? || Rails.configuration.are_videos_public
  end

  def show?
    (user.present? || Rails.configuration.are_videos_public) && (record.built? || user == record.owner)
  end

  def new?
    user.present? && user == record.owner
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  def like?
    user.present?
  end

  def unlike?
    user.present?
  end
  
end
