def login_user(user)
  user = create :user if user.nil?

  post api_v1_user_session_path, {
    params: { email: user[:email], password: user[:password] }
  }
  JSON.parse(response.body)
end

def generate_headers(user = nil)
  user = create :user if user.nil?
  user.create_new_auth_token
end
