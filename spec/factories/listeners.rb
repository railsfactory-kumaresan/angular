FactoryGirl.define do
  factory :listener_first,class: Listener do
    client_id "8a5ca90f-cffc-4bdf-81b6-d9563d874b8a"
    user_id 1
    email "ferdinand@railsfactory.org"
    company_name "company name"
    username "ferdi8a5c"
    password "Pwddna8a5"
    status "Open"
    is_active false
    is_requested true
  end
    factory :listener_open,class: Listener do
    client_id "8a5ca90f-cffc-4bdf-81b6-d9563ddfg4b8a"
    user_id 3
    email "ferdinandrosario@gmail.com"
    company_name "company name"
    username "ferdisd8a5c"
    password "Pwddnagaa8a5"
    status "Open"
    is_active false
    is_requested true
  end
    factory :listener_closed,class: Listener do
    client_id "8a5ca90f-cffc-4bdf-81b6-d956sh874b8a"
    user_id 5
    email "ferdinandrosario@hotmail.com"
    company_name "company name"
    username "ferdigfgf8a5c"
    password "Pwddsfna8a5"
    status "Closed"
    is_active true
    is_requested true
  end
    factory :listener_four,class: Listener do
    client_id "8a5ca90f-cffc-4bdf-81b6-d9563d87qw28a"
    user_id 7
    email "ferdinandd@railsfactory.org"
    company_name "company name"
    username "ferdisfd8a5c"
    password "Pwddna8asasd5"
    status "Closed"
    is_active true
    is_requested true
  end
  
  factory :existing_listener,class: Listener do
    client_id "8a5ca90f-cffc-4bdf-81b6-d9563d87qw28a"
    user_id 7
    email "ferdinandd@railsfactory.org"
    company_name "company name"
    username "ferdisfd8a5c"
    password "Pwddna8asasd5"
    status "Closed"
    is_active true
    is_requested true
  end
  
end