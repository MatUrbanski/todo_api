# frozen_string_literal: true

# {User} model stores authentication informations.
#
# @!attribute id
#   @return [UUID] ID of the {User} in UUID format.
#
# @!attribute email
#   @return [String] Email of the {User}, it's stored in the PostgreSQL citext column.
#
# @!attribute password_digest
#   @return [String] {User} hashed password with bcrypt.
#
# @!attribute authentication_token
#   @return [String] Unique token among all users({User}) that is used during authorization token verification.
#
# @!attribute created_at
#   @return [DateTime] Time when {User} was created.
#
# @!attribute updated_at
#   @return [DateTime] Time when {User} was updated.
class User < Sequel::Model
  # Plugin that adds BCrypt authentication and password hashing to Sequel models.
  plugin :secure_password

  one_to_many :todos

  # It validates {User} object.
  #
  # @example Validate {User}:
  #   User.new.validate
  def validate
    super

    validates_format(Constants::EMAIL_REGEX, :email) if email
  end
end
