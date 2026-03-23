class Page < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  def to_param
    slug
  end

  private

  def set_slug
    return unless title.present? && slug.blank?
    candidate = title.parameterize
    # parameterize strips CJK characters — fall back to the title itself
    self.slug = candidate.presence || title.strip
  end
end
