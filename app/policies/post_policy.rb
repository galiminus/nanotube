class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where("(posts.owner_id = ? OR posts.state = ?)", user.id, "built")
    end
  end

  def permitted_attributes
    [
    ]
  end

  def index?
    true
  end

  def show?
    record.built? || user == record.owner
  end

  def new?
    user == record.owner
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
