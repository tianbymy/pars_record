# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
#  acts_as_messageable
  has_one :role
  delegate :name,:marked,:to => :role,:prefix => true
#  attr_accessible :login, :email, :enterprise_id, :password,:number, :password_confirmation,:temporary_password,:area_id

#  merge_validates_format_of_login_field_options({:message => I18n.t('error_messages.login_invalid',:default => '请使用字母或数字组成帐号')})
#  merge_validates_length_of_login_field_options({:message => I18n.t('error_messages.login_invalid',:default => '不能为空')})
#  merge_validates_uniqueness_of_login_field_options({:message => I18n.t('error_messages.login_invalid',:default => '已经注册')})
#  merge_validates_format_of_email_field_options({:message => I18n.t('error_messages.email_invalid', :default => '格式不正确（example@example.com）')})
#  merge_validates_uniqueness_of_email_field_options({:message => I18n.t('error_messages.email_invalid',:default => '已经注册')})
#  merge_validates_length_of_password_field_options({:message => I18n.t('error_messages.password_invalid',:default => '必须为6位')})
#  merge_validates_confirmation_of_password_field_options({:message => I18n.t('error_messages.password_invalid',:default => '两次输入不一致')})
#  acts_as_authentic 

  def self.make account
     if account == nil then Account.new else account end
  end

  def display_name
    return "You should add method :name in your Messageable model"
  end

  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return "yangjunfeng@zhiyisoft.com"
    #if false
    #return nil
  end

  def self.make_number locality,nature
    count=EnterpriseLocality.find_all_by_area_id(locality).size
    if nature == 1
      get_number(count,"1000",enterprise_str((count+1).to_s))
    else
      get_number(count,"8000",park_str((count+1).to_s))
    end
  end

  def self.user_id_exist(user_id)
    return user_id if user_id_exist?(user_id)
    user_id_exist(user_id_dispose(user_id))
  end

  def self.user_id_exist?(user_id)
    user=where(:login => user_id).first
    user.nil?
  end

  def self.user_id_dispose(user_id)
    locality_marked=user_id[0,4]
    number=user_id[4,7]
    locality_marked+(number.to_i+1).to_s
  end

  def self.save_info number, password, enterprise
    user = User.new(:login => number, :password => password,:password_confirmation => password,:email => (number+"@"+number+".com"),:number => number,:temporary_password => password)
    user.save
    Role.new(:user_id => user.id,:name => "enterprise",:marked => enterprise).save
    user
  end

  def self.newpass len
    chars = ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size)] }
    return newpass
  end

  def self.get_sender user
    unless user.nil?
      return "管理员" if user.role.nil?
      "四川省"
    end
  end

  def self.get_recipient_by_sender recipients,sender
    get_recipient(get_recipient_id(recipients,sender))
  end

  def self.get_recipient user_id
    user=User.find(user_id)
    if user.role.nil?
      "管理员"
    else
      return Enterprise.find(user.role_marked).name if user.role_name == "enterprise"
      area=Area.find(user.role_marked)
      area.city_name+area.name
    end
  end

  private
  def self.get_recipient_id recipients,sender
    recipient_id=""
    recipients.each do |user|
        recipient_id=user.id
    end
    recipient_id
  end
  def self.enterprise_str value
    if value.length == 4
      value
    else
      result=""
      result ="1"
      for i in 1..(3-value.length)
        result += "0"
      end
      result+value
    end
  end

  def self.park_str value
    if value.length == 4
      value
    else
      result=""
      result ="8"
      for i in 1..(3-value.length)
        result += "0"
      end
      result+value
    end
  end

  def self.get_number count,init_value,new_value
    if count > 0
      new_value
    else
      init_value
    end
  end
end
