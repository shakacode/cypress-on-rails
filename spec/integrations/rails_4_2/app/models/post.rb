class Post < OpenStruct
  def self.create(attributes)
    @all ||= []
    post = new(attributes)
    @all << post
    attributes['all'] = @all.index(post)
  end

  def self.all
    @all ||= []
    @all
  end

  def self.delete_all
    @all = []
  end
end
