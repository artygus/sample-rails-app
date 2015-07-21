class Trip < ActiveRecord::Base
  belongs_to :user

  validates :destination, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true

  validate :start_date_cannot_be_greater_than_end_date

  def start_date_cannot_be_greater_than_end_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:start_date, "can't be greater than end_date value")
    end
  end
end
