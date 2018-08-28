class Micropost < ApplicationRecord
  belongs_to :user
  scope :scope_sort, ->{order created_at: :desc}
  scope :feed, ->{where user_id: ids}
  mount_uploader :picture, PictureUploader
  validates :content, presence: true,
    length: {maximum: Settings.maximum.micropost}
  validate :picture_size

  private
  def picture_size
    return if picture.size <= Settings.picture.size.megabytes
    errors.add :picture, t("picture_error")
  end
end
