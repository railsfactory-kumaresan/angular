class CountsStore < ActiveRecord::Base
store_accessor :counts_key, [:tkc,:am17,:af17,:am25,:af25,:am30,:af30,:am35,:af35,:am40,:af40,:am45,:af45,:am50,:af50,:am00,:af00,
                            :m, :f,
                            :mail, :call, :sms, :embed, :qr,
                            :fb, :tw, :lk]

# Find the group record for increment
def self.find_for_increment(question_id_p, vrtype_p, country_p, norm_date_p)
  country_p = country_p.blank? ? nil : country_p.upcase
   count_group = CountsStore.find_or_create_by(question_id: question_id_p,
                 vrtype: vrtype_p,
                 country: country_p,
                 norm_date: norm_date_p)
  count_group
end



def self.find_counts_store(question_id_p, vrtype_p, country_p, norm_date_p)
  #country_p = country_p.blank? ? nil : country_p.upcase
   count_group = CountsStore.where(question_id: question_id_p,
                 vrtype: vrtype_p,
                 country: country_p,
                 norm_date: norm_date_p)
  count_group
end


# #Find the group record for location getter
# def self.find_for_location(question_id_p, vrtype_p,  norm_date_p)
#   count_group = CountsStore.where("question_id=? AND
#                 vrtype=?  AND
#                 norm_date=?" , question_id_p, parent_id_p, tenant_id_p, vrtype_p,  norm_date_p)
#   count_group
# end


def self.get_counts(question_ids,params,vrtype)
    qry = self.get_conditions(question_ids,params,vrtype)
  unless qry.blank?
self.select("sum((counts_key->'f')::Integer) as f_count, vrtype,question_id, sum((counts_key->'m')::Integer) as m_count,
                                    sum((counts_key->'mail')::Integer) as mail_count,
                                    sum((counts_key->'embed')::Integer) as embed_count,
                                    sum((counts_key->'sms')::Integer) as sms_count,
                                    sum((counts_key->'call')::Integer) as call_count,
                                    sum((counts_key->'lk')::Integer) as lk_count,
                                    sum((counts_key->'fb')::Integer) as fb_count,
                                    sum((counts_key->'qr')::Integer) as qr_count,
                                    sum((counts_key->'tw')::Integer) as tw_count,
                                    sum((counts_key->'am17')::Integer) as am17_count,
                                    sum((counts_key->'af17')::Integer) as af17_count,
                                    sum((counts_key->'am25')::Integer) as am25_count,
                                    sum((counts_key->'af25')::Integer) as af25_count,
                                    sum((counts_key->'am30')::Integer) as am30_count,
                                    sum((counts_key->'af30')::Integer) as af30_count,
                                    sum((counts_key->'am35')::Integer) as am35_count,
                                    sum((counts_key->'af35')::Integer) as af35_count,
                                    sum((counts_key->'am40')::Integer) as am40_count,
                                    sum((counts_key->'af40')::Integer) as af40_count,
                                    sum((counts_key->'am45')::Integer) as am45_count,
                                    sum((counts_key->'af45')::Integer) as af45_count,
                                    sum((counts_key->'am50')::Integer) as am50_count,
                                    sum((counts_key->'af50')::Integer) as af50_count,
                                    sum((counts_key->'am00')::Integer) as am00_count,
                                    sum((counts_key->'af00')::Integer) as af00_count
                                     ").where(qry).group("question_id,vrtype")
else
  {}
end
end


def self.get_counts_static_location(question_ids,params,vr_type)
  qry = self.get_conditions(question_ids,params,vr_type)
  @location = {}
  unless qry.blank?
  vr_collection = CountsStore.select("vrtype as vrtype,country,sum((counts_key->'tkc')::Integer) as count").where("#{qry} and country != ''").group("country,vrtype")
  vr_collection.each do |vr|
   @location["#{vr.country}"] = {} if @location["#{vr.country}"].nil?
   @location["#{vr.country}"].merge!({"#{vr.vrtype}" => vr.count})
  end
  return @location
else
  {}
end
end

def self.get_counts_static_chart(question_ids,params,vrtype)
qry = self.get_conditions(question_ids,params,vrtype)
unless qry.blank?
vr_collection = CountsStore.select("norm_date,vrtype,(sum((counts_key->'mail')::Integer) +
                                    sum((counts_key->'embed')::Integer) +
                                    sum((counts_key->'sms')::Integer) +
                                    sum((counts_key->'call')::Integer) +
                                    sum((counts_key->'lk')::Integer) +
                                    sum((counts_key->'fb')::Integer) +
                                    sum((counts_key->'qr')::Integer) +
                                    sum((counts_key->'tw')::Integer)) as total_count").where(qry).group("norm_date,vrtype").order("norm_date asc")
return vr_collection
else
  {}
end
end

private

def self.get_conditions(question_ids,params,vr_type)
  from_date,to_date = params[:from_date],params[:to_date]
  norm_date = DEFAULTS['norm_date']
   unless question_ids.blank?
    question_ids = question_ids.join(',')
    qry = "question_id in (#{question_ids})"
    qry += " and vrtype = '#{vr_type}'" if !vr_type.nil? && vr_type != "viewed_norm_date" && vr_type != "responded_norm_date"
    #qry += " and is_responded = 'YES'" if vr_type == "responded_norm_date"
    if from_date.present? && to_date.present?
      from_normd = (Date.parse("#{from_date}") - Date.parse("#{norm_date}")).to_i + 1
      to_normd = (Date.parse("#{to_date}") - Date.parse("#{norm_date}")).to_i + 1
      column = (vr_type == "viewed_norm_date" || vr_type == "responded_norm_date") ? vr_type : "norm_date"
      qry += " and #{column} >= #{from_normd} and #{column} <= #{to_normd} " if from_date.present? && to_date.present?
    end
    qry
  else
   {}
  end
end


end