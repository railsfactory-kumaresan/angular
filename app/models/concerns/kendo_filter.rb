module KendoFilter
  extend ActiveSupport::Concern
  included do

    def self.get_customer_records(user_id,type,sort,filter,logic,limit)
      if sort.nil? && filter.nil?
        get_client_records(user_id,type,limit)
      elsif sort.present? && !filter.present?
        get_sorted_records(user_id,type,sort,limit)
      elsif filter.present? && !sort.present?
        get_filtered_records(user_id,type,filter,logic,limit)
      else
        get_sort_and_filter_records(user_id,type,filter,sort,logic,limit)
      end
    end

    def self.get_client_records(user_id,type,limit)
      if type == "email_count"
        where("user_id =? and is_deleted is NULL and email != ?", user_id, "").limit(limit).order(:id => :desc)
      elsif type == "call_count" || type == "sms_count"
        where("user_id =? and is_deleted is NULL and mobile != ?", user_id,"").limit(limit).order(:id => :desc)
      else
        where("user_id =? and is_deleted is NULL",user_id).limit(limit).order(:id => :desc)
      end
    end

    def self.get_sorted_records(user_id,type,sort,limit)
      if type == "email_count"
        where("user_id =? and is_deleted is NULL and email != ?", user_id, "").limit(limit).order("#{sort["column"]} #{sort["by"]}")
      elsif type == "call_count" || type == "sms_count"
        where("user_id =? and is_deleted is NULL and mobile != ?", user_id,"").limit(limit).order("#{sort["column"]} #{sort["by"]}")
      else
        where("user_id =? and is_deleted is NULL",user_id).limit(limit).order("#{sort["column"]} #{sort["by"]}")
      end
    end

    def self.get_filtered_records(user_id,type,filter,logic,limit)
      condition = filter_condition(filter,logic)
      if type == "email_count"
        where("user_id =? and is_deleted is NULL and email != ? #{condition}", user_id, "").limit(limit)
      elsif type == "call_count" || type == "sms_count"
        where("user_id =? and is_deleted is NULL and mobile != ? #{condition}", user_id,"").limit(limit)
      else
        where("user_id =? and is_deleted is NULL #{condition}",user_id).limit(limit)
      end
    end

    def self.get_sort_and_filter_records(user_id,type,filter,sort,logic,limit)
      condition = filter_condition(filter,logic)
      if type == "email_count"
        where("user_id =? and is_deleted is NULL and email != ? #{condition}", user_id, "").limit(limit).order("#{sort["column"]} #{sort["by"]}")
      elsif type == "call_count" || type == "sms_count"
        where("user_id =? and is_deleted is NULL and mobile != ? #{condition}", user_id,"").limit(limit).order("#{sort["column"]} #{sort["by"]}")
      else
        where("user_id =? and is_deleted is NULL #{condition}",user_id).limit(limit).order("#{sort["column"]} #{sort["by"]}")
      end
    end

    def self.filter_condition(filter,logic)
      @condition = ""
      filter.each do |k,val|
        if val['logic'].present?
          val['filters'].each do |s_k,s_v|
            s_v['value'] = s_v['value'].downcase if s_v['field'] == 'gender'
            s_v['value'] = get_country_info(s_v['value']) if s_v['field'] == 'country'
            @condition += " #{val['logic']}"
            @condition += " #{s_v['field']} #{find_operator(s_v['operator'], s_v['value'])}"
          end
        else
          val['value'] = val['value'].downcase if val['field'] == 'gender'
          val['value'] = get_country_info(val['value']) if val['field'] == 'country'
          @condition += " #{logic}"
          @condition += " #{val['field']} #{find_operator(val['operator'], val['value'])}"
        end
      end
      return @condition
    end

    def self.get_country_info(value)
      Country.find_country_by_name(value).nil? ? value : Country.find_country_by_name(value).alpha2
    end

    def self.total_records_count(user_id,type,filter,logic)
      condition = filter.nil? ? "" : filter_condition(filter,logic)
      if type == "email_count"
        where("user_id =? and is_deleted is NULL and email != ? #{condition}", user_id, "").count
      elsif type == "call_count" || type == "sms_count"
        where("user_id =? and is_deleted is NULL and mobile != ? #{condition}", user_id,"").count
      else
        where("user_id =? and is_deleted is NULL #{condition}",user_id).count
      end
    end

    def self.find_operator(operator, value)
      case operator
        when 'neq'
          "!= ('#{value}')"
        when 'lt'
          "< ('#{value}')"
        when 'lte'
          "<= ('#{value}')"
        when 'gt'
          "> ('#{value}')"
        when 'gte'
          ">= ('#{value}')"
        when 'startswith'
          "ILIKE ('#{value}%')"
        when 'endswith'
          "ILIKE ('%#{value}')"
        when 'contains'
          "ILIKE ('%#{value}%')"
        when 'doesnotcontain'
          "NOT ILIKE ('%#{value}%')"
        else
          "= ('#{value}')"
      end
    end
  end
end