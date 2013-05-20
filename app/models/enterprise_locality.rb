# -*- coding: utf-8 -*-
class EnterpriseLocality < ActiveRecord::Base
  belongs_to :city
  delegate :number,:name,:to => :city,:prefix => true
  belongs_to :area
  delegate :number,:name,:status,:to => :area,:prefix => true
  belongs_to :enterprise
  delegate :name,:to => :enterprise,:prefix => true
  attr_accessible :enterprise_id,:city_id,:area_id

  scope :get_by_city,(lambda do |city_id|
    where(:city_id => city_id)
  end)

  scope :get_by_area,(lambda do |area_id|
    where(:area_id => area_id)
  end)

  validates_presence_of :area_id,:message => "不能为空"

  def self.get_enterprise_ids localities
    enterprise_ids=Array.new
    localities.each do |locality|
      enterprise_ids.push(locality.enterprise_id)
    end
    enterprise_ids
  end
end
