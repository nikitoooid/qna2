class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validate :validate_url_format

  private

  def validate_url_format
    errors.add(:url, 'Url is not valid') unless valid_url?(url)
  end

  def valid_url?(url)
    url = begin
      URI.parse(url)
    rescue StandardError
      false
    end
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end
