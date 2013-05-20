# -*- coding: utf-8 -*-
class EnterpriseNature < ActiveRecord::Base
  belongs_to :nature
  delegate :name,:to => :nature
  has_one :enterprise
  attr_accessible :enterprise_id,:nature_id
  validates_presence_of :nature_id,:message => "不能为空"
end
