class TripsController < ApplicationController
  before_filter :require_login
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = current_user.trips
  end

  def travelplan
    @from = Time.now.beginning_of_month.next_month.to_date
    to = Time.now.end_of_month.next_month.to_date
    @trips = current_user.trips.where('start_date BETWEEN ? AND ?', @from, to)

    respond_to do |format|
      format.html { render :travelplan, layout: 'print', locals: {trips: @trips} }
      format.json { render :index }
    end
  end

  def search
    @trips = current_user.trips

    if params[:q].present?
      db_query = "%#{params[:q]}%"
      @trips = @trips.where('comment LIKE ? OR destination LIKE ?', db_query, db_query)
    end

    respond_to do |format|
      format.html { render :search, layout: false, locals: {trips: @trips} }
      format.json { render :index }
    end
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def edit
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :comment)
  end
end
