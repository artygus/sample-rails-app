require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) {
    {
      email: 'test@email.com',
      rank: 'admin',
      password: '123'
    }
  }

  it "creates user with valid attributes" do
    user = User.create! valid_attributes
    expect(user.id).to_not eq(nil)
  end

  it "requires email field presence" do
    user = User.create valid_attributes.merge(email: nil)
    expect(user.errors.size).to eq(2)
  end

  it "check if email address valied" do
    user = User.create valid_attributes.merge(email: 'not_email')
    expect(user.errors.size).to eq(1)
  end

  it "requires rank correctness" do
    user = User.create valid_attributes.merge(rank: 'random')
    expect(user.errors.size).to eq(1)
  end

  it "destroys dependant trips" do
    user = User.create! valid_attributes
    trip = Trip.create!({
      destination: 'Honk Kong',
      start_date: Time.now.to_date,
      end_date: Time.now.to_date + 7.days,
      user_id: user.id
    })

    user.destroy
    expect{ trip.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

end
