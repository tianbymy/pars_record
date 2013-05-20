class City < ActiveRecord::Base

  has_one :enterprise_locality
  has_many :areas
  attr_accessible :name,:number,:status

end
