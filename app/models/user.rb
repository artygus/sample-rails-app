class User < ActiveRecord::Base
  include Clearance::User

  RANKS = %w(user admin)

  has_many :trips, dependent: :destroy
  validates :rank, inclusion: { in: RANKS, message: "%{value} is not a valid rank" }

  def admin?
    rank == 'admin'
  end
end
