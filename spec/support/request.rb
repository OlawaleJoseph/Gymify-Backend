require 'json'

def post_request(url, params, headers)
  post url, params: params, headers: headers
end
