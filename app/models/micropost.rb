class Micropost < ApplicationRecord
  belongs_to :user
  scope :scope_sort, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader
  validates :content, presence: true,
    length: {maximum: Settings.maximum.micropost}
  validate :picture_size
  # following_ids = "SELECT followed_id FROM relationships
  #                    WHERE  follower_id = :user_id"
  # scope :feed, ->{where "user_id IN (#{following_ids})
  #                    OR user_id = :user_id", user_id: ids}
  private
  def picture_size
    return if picture.size <= Settings.picture.size.megabytes
    errors.add :picture, t("picture_error")
  end
end
