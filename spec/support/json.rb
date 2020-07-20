def post_json(path, body)
  post path, Oj.dump(body), {'CONTENT_TYPE' => 'application/json'}
end

def response_json
  Oj.load(last_response.body)
end
