class Post < OpenStruct
  def self.create!(attributes)
    create(attributes)
  end

  def self.create(attributes)
    @all ||= []
    post = new(attributes)
    @all << post
    post.id = @all.index(post)
    attributes['id'] = @all.index(post)
    attributes
  end

  def self.all
    @all ||= []
    @all
  end

  def self.delete_all
    @all = []
  end
end
