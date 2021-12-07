class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  add_flash_types :danger, :warning, :success, :info
end
