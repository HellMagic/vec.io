class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  attr_accessible :slug, :title, :content, :tags, :tags_str

  field :slug, type: String
  field :title, type: String
  field :content, type: String

  index({ slug: 1 }, { unique: true })
  index({ title: 1 }, { unique: true })

  slug :slug

  validates_presence_of :slug, :title, :content, allow_blank: false
  validates_uniqueness_of :slug, :title, case_sensitive: false, allow_blank: true

  belongs_to :user, index: true
  has_many :assets, as: :attachable, autosave: true, dependent: :destroy
  has_and_belongs_to_many :tags, autosave: true

  def tags_str
    self.tags.map(&:title).join(',')
  end

  def tags_str=(str)
    str.split(',').uniq.each { |t|
      tag = Tag.find_or_initialize_by(title: t)
      self.tags << tag unless self.tags.include? tag
    }
  end

  after_save do |p|
    p.tags.each { |t| t.set(:count, t.posts.count) }
  end

  after_destroy do |p|
    p.tags.each { |t| t.set(:count, t.posts.count) }
  end
end
