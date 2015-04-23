module SharesHelper

  def email_content_trim(email_content)
    email_content_trim = email_content.gsub( / *\n+/, "\n" )
    email_content_trim_new = email_content_trim.include?("survey link inserted here automatically") ? email_content_trim : email_content_trim + "&lt;survey link inserted here automatically&gt;"
    return email_content_trim_new.gsub("\n", "<br>").html_safe
  end

  def is_sso
    session[:sso] ? true : false
  end

  def share_error_msg(type)
    type == "email" ? "Please select at least one email address." : "Please select at least one mobile number."
  end

  def share_button_value(type)
    type == "email" ? "Add Selected Emails" : "Add Selected Mobile Numbers"
  end

  def parse_table_view(response,type)
   type = (type == 'sms' || type == 'voice') ? 'mobile' : type
   unless response.blank?
    header = response.first.keys.map(&:upcase)
    values = []
    options = []
    response.each do |data|
      value = []
      data.each do |key, val|
         options << val if key == type
         value << val
      end
      values << value
    end
    {"tableData" => {"header" => header,"rows" => values, "options" => options}}.to_json.html_safe
   end
  end

  def grid_filter_condition(filter)
    select_box_block = ""
    responsive_block = "<div class='filterby text-right'><div class='hoz-form form-inline' style='margin: 3px;'>"
    filter.each do |value|
      select_box_block += search_container(value)
    end
    responsive_block_end ="<button class='button medium orange' id='customer_list_filter' type='submit' tabindex='4'>Search</button></div></div>"
    (responsive_block + select_box_block + responsive_block_end).html_safe
  end

  def search_container(filter_value)
    fields_block = ""
    form_group = "<div class='form-group' style='margin: 3px;'>"
    if filter_value["filter-type"] == "dropdown"
      fields_block += select_box_block(filter_value["label"],filter_value["data"],filter_value["name"])
    elsif filter_value["filter-type"] == "text"
      fields_block += text_box_block(filter_value["label"],filter_value["data"],filter_value["name"])
    end
    form_group_end = "</div>"
    form_group + fields_block + form_group_end
  end

  def text_box_block(label,data,name)
    "<input class='text_field rc_5 form-control input-small' id='#{label.downcase}_id' name='#{name}' placeholder='#{label}'  type='text' value='#{data}'>"
  end

  def select_box_block(label,data,name)
    option = "<option value=''>All #{label}</option>"
    select_start = "<select class='form-control input-small' id='#{label.downcase}_list' name='#{name}'>"
    data.each do |value|
      value.is_a?(Hash) ? option += "<option value='#{value["centre_key"]}'>#{value["centre_name"]}</option>" : option += "<option value='#{value}'>#{value}</option>"
    end
    select_end = "</select>"
    select_start + option + select_end
  end

  def email_contact_list_path
    is_sso ? '<a href="javascript:void (0);" id="add-emails" onclick="share_grid_request(\'email\')">Add emails from a list</a>' : '<a href="javascript:void (0);" id="email-field" onclick="share_email_popup_load(\'email_count\')">Add emails from a list</a>'
  end
  
   def page_entries_info(collection, options = {})
      model = options[:model]
      model = collection.first.class unless model or collection.empty?
      model ||= 'entry'
      model_key = if model.respond_to? :model_name
                    model.model_name.i18n_key  # ActiveModel::Naming
                  else
                    model.to_s.underscore
                  end

      if options.fetch(:html, true)
        b, eb = '<b>', '</b>'
        sp = '&nbsp;'
        html_key = '_html'
      else
        b = eb = html_key = ''
        sp = ' '
      end

      model_count = collection.total_pages > 1 ? 5 : collection.size
      defaults = ["models.#{model_key}"]
      defaults << Proc.new { |_, opts|
        if model.respond_to? :model_name
          model.model_name.human(:count => opts[:count])
        else
          name = model_key.to_s.tr('_', ' ')
          raise "can't pluralize model name: #{model.inspect}" unless name.respond_to? :pluralize
          opts[:count] == 1 ? name : name.pluralize
        end
      }
      model_name = will_paginate_translate defaults, :count => model_count

      if collection.total_pages < 2
        i18n_key = :"page_entries_info.single_page#{html_key}"
        keys = [:"#{model_key}.#{i18n_key}", i18n_key]

        will_paginate_translate keys, :count => collection.total_entries, :model => model_name do |_, opts|
          case opts[:count]
          when 0; "No #{opts[:model]} found"
          when 1; "Displaying #{b}1#{eb} #{opts[:model]}"
          else    "Displaying #{b}all#{sp}#{opts[:count]}#{eb} #{opts[:model]}"
          end
        end
      else
        i18n_key = :"page_entries_info.multi_page#{html_key}"
        keys = [:"#{model_key}.#{i18n_key}", i18n_key]
        params = {
          :model => model_name, :count => collection.total_entries,
          :from => collection.offset + 1, :to => collection.offset + collection.length
        }
        will_paginate_translate keys, params do |_, opts|
          %{Displaying %s #{b}%d#{sp}-#{sp}%d#{eb} of #{b}%d#{eb} in total} %
            [ opts[:model], opts[:from], opts[:to], opts[:count] ]
        end
      end
     end
end