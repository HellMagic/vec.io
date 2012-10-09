class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::History::Trackable

  attr_accessible :published, :title, :content, :tags, :tags_str

  field :published, type: Boolean
  field :title, type: String
  field :content, type: String

  index({ title: 1 }, { unique: true })

  slug :title, permanent: true, history: true

  validates_presence_of :title, :content, allow_blank: false
  validates_uniqueness_of :title, case_sensitive: false, allow_blank: true

  belongs_to :user, index: true
  has_many :assets, as: :attachable, autosave: true, dependent: :destroy
  has_and_belongs_to_many :tags, autosave: true

  paginates_per 16

  track_history :on => [:published, :title, :content]

  scope :published, where(published: true)

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
    p.tags.each { |t| t.set(:count, t.posts.published.count) }
  end

  after_update do |p|
    p.set(:created_at, p.updated_at) if p.changes['published'] && p.changes['published'][1]
  end

  after_destroy do |p|
    p.tags.each { |t| t.set(:count, t.posts.published.count) }
  end
end
