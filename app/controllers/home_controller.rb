# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  def index

  end

  def get_city
    @data = []
    citys = City.all
    citys.each do |city|
      city["child"] = Area.where("city_id" =>city.id)
      @data.push(city)
    end
    return @data
  end


  def get_city_account
    @data=[]
    i=0
    citys = City.all
    citys.each do |c|
      Area.where(:city_id => c.id).each do |a|
        if role = Role.where(:marked => a.id,:name =>"city").first
          if user = User.where(:id => role.user_id).first
            @data[i] = user
            @data[i]["city"] = c.name
            @data[i]["area"] = a.name
            i=i+1
          end
        end
      end
    end
    p @data.size
    render :json => @data
  end
  def get_finance_account
    @data = []
    i=0
    citys = City.all
    citys.each do |c|
      Area.where(:city_id => c.id).each do |a|
        if role = Role.where(:marked => a.id,:name =>"finance").first
          if user = User.where(:id => role.user_id).first
            @data[i] = user
            @data[i]["city"] = c.name
            @data[i]["area"] = a.name
            i=i+1
          end
        end
      end
    end
    p @data.size
    render :json => @data
  end

  def get_enterprise_account
    @data =[]
    i=0
    citys = City.all
    citys.each do |c|
      Area.where(:city_id => c.id).each do |a|
        EnterpriseLocality.where(:city_id => c.id, :area_id =>a.id).each do |e|
          if enterprise = Enterprise.where(:id => e.id).first
            if nature = EnterpriseNature.where(:enterprise_id => e.id).first
              if role = Role.where(:marked => e.enterprise_id,:name =>"enterprise").first
                if user = User.where(:id => role.user_id).first
                  @data[i] = user
                  @data[i]["city"] = c.name
                  @data[i]["area"] = a.name
                  @data[i]["enterprise"] = enterprise.name
                  i=i+1
                end
              end
            end
          end
        end
      end
    end
    p @data.size
    render :json => @data
  end

 def get_special
   @data = Area.where(status: 1)
   @data.each_with_index do |a,i|
     @data[i] = a.name
   end
   render :json =>@data
 end

end
