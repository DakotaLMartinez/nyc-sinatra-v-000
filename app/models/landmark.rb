class Landmark < ActiveRecord::Base
  belongs_to :figure
  include Concerns::Slugifiable
  extend Concerns::Findable
end
