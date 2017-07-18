module Helpers
  module_function

  def get_secret(username)
    TestLogger.info("Get auth code...")
    code_id = get_code_from_db(username)

    if code_id.nil?
      TestLogger.fatal("Code for #{username} not found")
      raise(Exception.new("Code for #{username} not found"))
    end

    secret = get_from_db(code_id)
  end

  # Remove user by username through API
  # @param username [String]
  # @return [void]
  def remove_user(username)
    TestLogger.info("Remove user #{username}...")
    user_id = get_user_id(username)

    raise(Exception.new("User_id for #{username} not found")) if user_id.nil?

    remove_user_by_id(user_id)
  end

  # Get user_id by username through API
  # @param username [String]
  # @return [String] User id
  def get_user_id(username)
    # .........
  end

  # Remove user by id through API
  # @param user_id [String]
  # @return [void]
  def remove_user_by_id(user_id)
    # ........
  end
end
