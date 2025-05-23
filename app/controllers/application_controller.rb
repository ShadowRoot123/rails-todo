class ApplicationController < ActionController::Base
  # Include helper for time formatting
  include ActionView::Helpers::DateHelper

  before_action :track_visit
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :formatted_time_ago, :greeting

  protected

  # Devise: Permit extra parameters like `username`
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def track_visit
    # Total visit counter
    session[:total_visit_count] ||= 0
    session[:total_visit_count] += 1

    # Page-specific visit counter
    session[:page_visits] ||= {}
    current_page_path = request.path
    session[:page_visits][current_page_path] ||= 0
    session[:page_visits][current_page_path] += 1

    # Record the time of the last visit
    session[:last_visited] = Time.current
  end

  # Custom time-ago helper (renamed to avoid conflict)
  def formatted_time_ago(from_time)
    distance_of_time_in_words(from_time, Time.current) + " ago"
  end

  # Time-based greeting
  def greeting
    current_hour = Time.current.hour

    case current_hour
    when 5..11 then "Good morning!"
    when 12..16 then "Good afternoon!"
    when 17..20 then "Good evening!"
    else "Good night!"
    end
  end
end
