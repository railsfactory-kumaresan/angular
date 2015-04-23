class DbViews

def perform
unless ActiveRecord::Base.connection.table_exists? "viewed_customer_details"

ViewedCustomerDetail.find_by_sql("create view viewed_customer_details as SELECT row_number() OVER () AS id,bc.id AS customer_id,
             vw.question_id AS question_id,
       qs.user_id as user_id,
       qs.question as question,
        vw.cookie_token_id as cookie_token_id,
        tn.name as tenant_name,
        qs.tenant_id as tenant_id,
        vw.created_at as viewed_at,
       (date(vw.created_at) - ('#{DEFAULTS['norm_date']}') + 1 ) AS viewed_norm_date,
       bc.country AS country,
       bc.state AS state,
       bc.city AS city,
       bc.area AS area,
bc.customer_name AS name,
bc.email AS email,
bc.mobile AS mobile,
bc.age AS age,
bc.gender AS gender,
bc.custom_field AS custom_field,
vw.provider as provider,
qs.created_at AS question_created_at
FROM question_view_logs vw
INNER JOIN questions qs ON vw.question_id = qs.id
FULL OUTER JOIN tenants tn on qs.tenant_id = tn.id
FULL OUTER JOIN business_customer_infos bc on (bc.id in (SELECT response_token_id from  response_cookie_infos res WHERE res.cookie_token_id = vw.cookie_token_id and qs.id = vw.question_id and res.response_token_type = 'BusinessCustomerInfo'))
where vw.question_id = qs.id and (bc.id is not null)")
end

unless ActiveRecord::Base.connection.table_exists? "responded_customer_details"

RespondedCustomerDetail.find_by_sql("create view responded_customer_details as SELECT row_number() OVER () AS id,bc.id AS customer_id,
             re.question_id AS question_id,
       qs.user_id as user_id,
       qs.question as question,
        re.cookie_token_id as cookie_token_id,
        tn.name as tenant_name,
        qs.tenant_id as tenant_id,
        re.created_at as responded_at,
        (date(re.created_at) - ('#{DEFAULTS['norm_date']}') + 1 ) AS responded_norm_date,
       bc.country AS country,
       bc.state AS state,
       bc.city AS city,
       bc.area AS area,
bc.customer_name AS name,
bc.email AS email,
bc.mobile AS mobile,
bc.age AS age,
bc.gender AS gender,
bc.custom_field AS custom_field,
re.provider as provider,
qs.created_at AS question_created_at
FROM question_response_logs re
INNER JOIN questions qs ON re.question_id = qs.id
FULL OUTER JOIN tenants tn on qs.tenant_id = tn.id
FULL OUTER JOIN business_customer_infos bc on (bc.id in (SELECT response_token_id from  response_cookie_infos res WHERE res.cookie_token_id = re.cookie_token_id and qs.id = re.question_id and res.response_token_type = 'BusinessCustomerInfo'))
where re.question_id = qs.id and (bc.id is not null)")
end



unless ActiveRecord::Base.connection.table_exists? "answer_option_details"
AnswerOptionDetail.find_by_sql("create view answer_option_details as  SELECT row_number() OVER () AS id,bc.id AS customer_id,qs.id AS question_id,
       qs.user_id as user_id,
       tn.name as tenant_name,
       tn.id as tenant_id,
       bc.country AS country,
       re.cookie_token_id AS cookie_token_id,
       bc.customer_name AS name,
       bc.email AS email,
       bc.mobile AS mobile,
       bc.age AS age,
       bc.state AS state,
       bc.city AS city,
       bc.area AS area,
bc.gender AS gender,
bc.custom_field AS custom_field,
  re.provider as provider,
       re.created_at AS responded_at,ans.option
FROM questions qs
inner JOIN answers ans on ans.question_id  = qs.id
FULL OUTER JOIN tenants tn on qs.tenant_id = tn.id
FULL OUTER JOIN question_response_logs re ON re.cookie_token_id = ans.uuid
FULL OUTER JOIN business_customer_infos bc on (bc.id in (SELECT response_token_id from  response_cookie_infos res WHERE res.cookie_token_id = re.cookie_token_id and qs.id = re.question_id and res.response_token_type = 'BusinessCustomerInfo'))
where ans.question_id = qs.id and ans.comments is null and re.question_id = qs.id and (bc.id is not null)")
end


end
end