##
# This token is used to track who does what
class CookieToken < ActiveRecord::Base
  #attr_protected
  #attr_accessible :uuid
  has_many :response_cookie_infos
  has_many :question_view_logs
  has_many :question_response_logs
  has_one :business_customer_info
  validates :uuid, :uniqueness => {:scope => [:uuid]}
  # searchable do
  #   integer :id, :stored => true
  #   string  :uuid,:stored => true
  # end

  ##
  # Creates a new cookie.
  #
  # *uuid* - Universally unique identifier.
  #
  # returns the created Cookie instance
  def self.create_new_record(uuid)
    self.create(uuid: uuid)
  end

  ##
  # Finds a cookie id with uuid
  #
  # *cookie_uuid* - The UUID in the cookie
  #
  # returns the *id* of the cookie
  def self.find_cookie_token_id(cookie_uuid)
    cookie = where(uuid: cookie_uuid).select('id')
    cookie.blank? ? nil : cookie.first.id
  end

  ##
  # Gets the response cookie or response token
  # if the response cookie is blank
  #
  # cookie_uuid - UUID of the Cookie
  def self.find_cookie_customer_info(cookie_uuid)
    cookie = where(uuid: cookie_uuid)
    unless cookie.blank?
      response_cookie = cookie.last.response_cookie_infos.last
      return response_cookie.response_token unless response_cookie.blank?
    end
  end

  ##
  # Given the id of the cookie, its customer information is obtained
  #
  # *id* - id of the cookie
  def self.find_customer_informations(id)
    cookie = where(id: id)
    unless cookie.blank?
      response_cookie = cookie.last.response_cookie_infos.last
      return response_cookie.response_token unless response_cookie.blank?
    end
  end
end
