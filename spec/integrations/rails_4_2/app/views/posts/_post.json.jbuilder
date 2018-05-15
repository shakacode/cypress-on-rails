json.extract! post, :id, :title, :body, :published, :amount, :tracking_id, :email, :created_at, :updated_at
json.url post_url(post, format: :json)
