require 'rails_helper'
require 'spec_helper'
require 'clearance/rspec'

RSpec.describe TripsController, type: :controller do
  context "unlogged" do
    describe "GET #index" do
      it "block unauthenticated access" do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "GET #travelplan" do
      it "block unauthenticated access" do
        get :travelplan
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "GET #search" do
      it "block unauthenticated access" do
        get :search
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "GET #show" do
      it "block unauthenticated access" do
        get :show, id: 1
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "GET #new" do
      it "block unauthenticated access" do
        get :new
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "GET #edit" do
      it "block unauthenticated access" do
        get :edit, id: 1
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "POST #create" do
      it "block unauthenticated access" do
        post :create
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "POST #update" do
      it "block unauthenticated access" do
        post :update, id: 1
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe "DELETE #destroy" do
      it "block unauthenticated access" do
        delete :destroy, id: 1
        expect(response).to redirect_to(sign_in_path)
      end
    end

  end

  context "logged_in" do
    before :each do
      @user = User.create!(email: 'test@mail.com', password: '123')
      sign_in_as(@user)
    end

    let(:valid_attributes) {
      {
        destination: 'Brasilia',
        start_date: Time.now.to_date,
        end_date: Time.now.to_date + 7.days,
        comment: 'what a comment',
        user_id: @user.id
      }
    }

    let(:invalid_attributes) {
      {
        destination: 'Hawaii',
        start_date: Time.now.to_date,
        end_date: Time.now.to_date - 7.days
      }
    }


    describe "GET #index" do
      it "assigns all trips as @trips" do
        trip = Trip.create! valid_attributes
        get :index
        expect(assigns(:trips)).to eq([trip])
      end

      it "sorts by start_date desc" do
        trip_1 = Trip.create! valid_attributes
        trip_2 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date - 1.day)
        trip_3 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date + 3.days)
        get :index
        expect(assigns(:trips)).to eq([trip_3, trip_1, trip_2])
      end
    end

    describe "GET #travelplan" do
      it "assigns next month trips to @trips" do
        trip_1 = Trip.create! valid_attributes
        trip_2 = Trip.create! valid_attributes.merge(start_date: Time.now.beginning_of_month.next_month, end_date: Time.now.beginning_of_month.next_month + 3.days)
        trip_3 = Trip.create! valid_attributes.merge(start_date: Time.now.end_of_month.next_month, end_date: Time.now.end_of_month.next_month + 3.days)
        trip_4 = Trip.create! valid_attributes.merge(start_date: (Time.now + 2.months), end_date: (Time.now + 3.months))
        trip_5 = Trip.create! valid_attributes.merge(start_date: Time.now.next_month.change(day: 10), end_date: Time.now.next_month + 2.weeks)
        get :travelplan
        expect(assigns(:trips)).to eq([trip_3, trip_5, trip_2])
      end
    end

    describe "GET #search" do
      before :each do
        @trip_1 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date + 1.day)
        @trip_2 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date + 5.days, comment: 'charter')
        @trip_3 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date - 1.day, destination: 'Brazil')
        @trip_4 = Trip.create! valid_attributes.merge(start_date: Time.now.to_date + 4.days)
      end

      it "assigns all trips as @trips if query is empty" do
        get :search
        expect(assigns(:trips)).to eq([@trip_2, @trip_4, @trip_1, @trip_3])
      end

      it "looks in destination field" do
        get :search, q: 'chart'
        expect(assigns(:trips)).to eq([@trip_2])
      end

      it "looks in comment field" do
        trip = Trip.create! valid_attributes
        get :search, q: 'zil'
        expect(assigns(:trips)).to eq([@trip_3])
      end
    end

    describe "GET #show" do
      it "assigns the requested trip as @trip" do
        trip = Trip.create! valid_attributes
        get :show, {:id => trip.to_param}
        expect(assigns(:trip)).to eq(trip)
      end
    end

    describe "GET #new" do
      it "assigns a new trip as @trip" do
        get :new
        expect(assigns(:trip)).to be_a_new(Trip)
      end
    end

    describe "GET #edit" do
      it "assigns the requested trip as @trip" do
        trip = Trip.create! valid_attributes
        get :edit, {:id => trip.to_param}
        expect(assigns(:trip)).to eq(trip)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Trip" do
          expect {
            post :create, {:trip => valid_attributes}
          }.to change(Trip, :count).by(1)
        end

        it "assigns a newly created trip as @trip" do
          post :create, {:trip => valid_attributes}
          expect(assigns(:trip)).to be_a(Trip)
          expect(assigns(:trip)).to be_persisted
        end

        it "redirects to the created trip" do
          post :create, {:trip => valid_attributes}
          expect(response).to redirect_to(Trip.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved trip as @trip" do
          post :create, {:trip => invalid_attributes}
          expect(assigns(:trip)).to be_a_new(Trip)
        end

        it "re-renders the 'new' template" do
          post :create, {:trip => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            destination: 'Morocco',
            start_date: (Time.now.to_date + 7.days).to_s,
            end_date: (Time.now.to_date + 8.days).to_s,
            comment: 'tickets in my pocket'
          }
        }

        it "updates the requested trip" do
          trip = Trip.create! valid_attributes
          put :update, {:id => trip.to_param, :trip => new_attributes}
          trip.reload
          expect(trip.destination).to eq(new_attributes[:destination])
          expect(trip.start_date.to_s).to eq(new_attributes[:start_date])
          expect(trip.end_date.to_s).to eq(new_attributes[:end_date])
          expect(trip.comment).to eq(new_attributes[:comment])
        end

        it "assigns the requested trip as @trip" do
          trip = Trip.create! valid_attributes
          put :update, {:id => trip.to_param, :trip => valid_attributes}
          expect(assigns(:trip)).to eq(trip)
        end

        it "redirects to the trip" do
          trip = Trip.create! valid_attributes
          put :update, {:id => trip.to_param, :trip => valid_attributes}
          expect(response).to redirect_to(trip)
        end
      end

      context "with invalid params" do
        it "assigns the trip as @trip" do
          trip = Trip.create! valid_attributes
          put :update, {:id => trip.to_param, :trip => invalid_attributes}
          expect(assigns(:trip)).to eq(trip)
        end

        it "re-renders the 'edit' template" do
          trip = Trip.create! valid_attributes
          put :update, {:id => trip.to_param, :trip => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested trip" do
        trip = Trip.create! valid_attributes
        expect {
          delete :destroy, {:id => trip.to_param}
        }.to change(Trip, :count).by(-1)
      end

      it "redirects to the trips list" do
        trip = Trip.create! valid_attributes
        delete :destroy, {:id => trip.to_param}
        expect(response).to redirect_to(trips_url)
      end
    end

  end

end
