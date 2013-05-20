# -*- coding: utf-8 -*-
class Area < ActiveRecord::Base
  has_one :enterprise_locality
  belongs_to :city
  delegate :number,:name,:to => :city,:prefix => true
  has_one :enterprise_info
  attr_accessible :city_id,:number,:name,:status

  def get_name
  	return self.city_name if [self.name].include?"直属"
  	self.city_name+self.name
  end
end
