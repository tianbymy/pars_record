# -*- coding: utf-8 -*-
class Enterprise < ActiveRecord::Base
  attr_accessible :number,:name,:state,:corporation_attributes,:contactor_attributes,:enterprise_info_attributes,:enterprise_locality_attributes,:enterprise_nature_attributes
  validates_presence_of :name, :message => "不能为空"
  validates_uniqueness_of :name,:message => "已经注册"


  has_one :enterprise_nature
  accepts_nested_attributes_for :enterprise_nature
  has_one :enterprise_locality
  accepts_nested_attributes_for :enterprise_locality
  has_one :corporation
  accepts_nested_attributes_for :corporation
  delegate :name,:idcard,:email,:to => :corporation,:prefix => true
  has_one :contactor
  accepts_nested_attributes_for :contactor
  delegate :email,:name,:phone,:telephone,:email,:to => :contactor,:prefix => true
  has_one :enterprise_info
  accepts_nested_attributes_for :enterprise_info
  delegate :address,:postal_code,:buiness_code,:createdate,:funds,:phone,:fax,:to => :enterprise_info,:prefix => true
=begin
  state_machine :state, :initial => :new do
    event :register do
      transition :new => :register
    end
  end
=end
  def self.member? enterprise
    ep = Enterprise.find_by_name(enterprise)
    if ep == nil then true else false end
  end

  def get_projects rule
    return [] if rule.nil?
    return [] if rule.project_year == ""
    Declare.where(:enterprise_id => self.id,:effective_time => rule.project_year).desc("declaredate")
  end

  def get_nature
    return "企业(机构)" if self.enterprise_nature.nature_id == 1
    "功能示范区"
  end
end
