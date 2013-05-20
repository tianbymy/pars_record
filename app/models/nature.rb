# -*- coding: utf-8 -*-
class Nature < ActiveRecord::Base
  has_one :enterprise_nature
  attr_accessible :name
end
