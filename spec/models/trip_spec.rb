require 'rails_helper'
require 'spec_helper'

RSpec.describe Trip, type: :model do
  let(:user) {
    User.create!(email: 'test@mail.com', password: '123')
  } 

  let(:valid_attributes) {
    {
      destination: 'Brasilia',
      start_date: Time.now.to_date,
      end_date: Time.now.to_date + 7.days,
      user_id: user.id
    }
  }

  it "requires destination field presence" do
    trip = Trip.create valid_attributes.merge(destination: nil)
    expect(trip.errors.size).to eq(1)
  end

  it "requires start_date field presence" do
    trip = Trip.create valid_attributes.merge(start_date: nil)
    expect(trip.errors.size).to eq(1)
  end

  it "requires end_date presence" do
    trip = Trip.create valid_attributes.merge(end_date: nil)
    expect(trip.errors.size).to eq(1)
  end

  it "requires user_id field presence" do
    trip = Trip.create valid_attributes.merge(user_id: nil)
    expect(trip.errors.size).to eq(1)
  end

  it "requires end_date to be greater than the start_date" do
    trip = Trip.create valid_attributes.merge(end_date: Time.now.to_date - 1.day)
    expect(trip.errors.size).to eq(1)
  end

end
