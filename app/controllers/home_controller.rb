class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'dashboard', only: [:index, :contact_us]

  respond_to :json, only: [:contact_us]
  respond_to :html, except: [:contact_us]

  def index
  end

  def send_contact_us
    contact_us = ContactUs.new(contact_us_permitted)
    if contact_us.save
      render json: { success: "Thank you for your request. We will contact you as soon as we review your message!" }, status: 200
    else
      render json: { errors: contact_us.errors }, status: 422
    end
  end

  private
  def contact_us_permitted
    params.require(:contact_us).permit(:name, :email, :subject, :body)
  end

end
