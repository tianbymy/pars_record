# -*- coding: utf-8 -*-
class Role < ActiveRecord::Base
  belongs_to :user
  delegate :login,:email,:temporary_password,:to => :user,:prefix => true
  attr_accessible :name, :user_id, :marked

  scope :get_by_name,(lambda do |name|
    where(:name => name)
  end)

  scope :get_by,(lambda do |name,marked|
    where(:name => name,:marked => marked)
  end)

  def self.get_by_marked role,marked
    if role == nil
      "/admin"
    else
      url=get_permissions(role.name)[:url]
      if url.include?marked
        url.gsub(marked,role.marked.to_s)
      else
        url
      end
    end
  end

  private
  def self.get_permissions marked
  	new_permission= nil
    ResolveFile.get_permission.each do |per|
      if per[:name] == marked
        new_permission=per
      end
    end
    new_permission
  end
end
