include ActiveAdmin
ActiveAdmin.register EmailActivity , namespace: :email_opens do

  actions :index
  action_item only:[:index] do
    question = Question.get_question(params[:slug])
    link_to "Back to Question dashboard", "/question/#{question.slug}"
  end

  menu false

  index :title => 'Email Opened customer details' do
    column("Question",:question) unless params[:slug].present?
    column("Opened At", :date)
    column("Name", :name)
    column("Email",:email)
    column("Mobile",:mobile)
    column("Country", :country)
    column("State",:state)
    column("Area",:area)
    column("City",:city)
    column("Age",:age)
    column("Gender") { |detail| detail.gender.capitalize if detail.gender}
    column("Tenant",:tenant_name)
    column("Custom Field",:custom_field)
    column("Opens",:opens)
  end

  csv do
    column :question unless params[:slug].present?
    column :date
    column :name
    column :email
    column :mobile
    column :country
    column :state
    column :area
    column :city
    column :age
    column('gender') { |detail| detail.gender.capitalize if detail.gender}
    column :tenant_name
    column :custom_field
    column :opens

  end


  sidebar :filters, only: :index do
     @email_open = true
     render :file => 'admin/filters/_email_open_filters', :locals => {:email_open => @email_open}
  end

  controller do

    def scoped_collection
       Question.fetch_activity_results(params,"opens")
    end

    # Overrides the Ransack search methods and uses default AR scopes
    def apply_filtering(collection)
      @filters = Question.get_advanced_filter_collection(collection,true,'open')
      Question.filtering_scopes.each do |scope|
        collection = collection.filter_by(scope, filter_params[scope], "email") unless filter_params[scope].blank?
      end
      return collection
    end

    def filter_params
      @filter_params = params[:email_activity] || {}
    end

  end
  
end
