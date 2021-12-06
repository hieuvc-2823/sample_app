class ApplicationController < ActionController::Base
  include SessionsHelper
  add_flash_types :danger, :warning, :success, :info
end
