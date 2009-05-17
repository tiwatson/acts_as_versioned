class PublishedPage < ActiveRecord::Base
  acts_as_versioned :published_column => 'published_at'
end

