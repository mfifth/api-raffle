class Campaign < ActiveRecord::Base
  has_many :submissions
end
