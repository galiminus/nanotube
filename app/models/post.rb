class Post < ApplicationRecord
  include AASM

  acts_as_votable
  acts_as_taggable
  
  belongs_to :owner, class_name: "User"

  has_many :comments
  
  validates_format_of :content_type, with: /video\/./
#  validates :md5, uniqueness: true
  validates :path, presence: true

  before_save :update_tag_list
  
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

  protected

  def update_tag_list
    self.tag_list = String(description).scan(/#([[:alnum:]]+)/).flatten
  end
end
