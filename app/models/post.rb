class Post < ApplicationRecord
  include AASM

  acts_as_votable
  
  belongs_to :owner, class_name: "User"

  validates_format_of :content_type, with: /video\/./
  validates :md5, uniqueness: true
  validates :path, presence: true

  aasm column: 'state' do

    state :enqueued, initial: true
    state :building
    state :build_failed
    state :built

    event :start_building do
      transitions from: :enqueued, to: :building
    end

    event :mark_as_build_failed do
      transitions from: :building, to: :build_failed
    end

    event :retry_build  do
      transitions from: :build_failed, to: :enqueued
    end

    event :mark_as_built do
      transitions from: :building, to: :built
    end

  end
end
