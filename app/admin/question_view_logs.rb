include ActiveAdmin
ActiveAdmin.register QuestionViewLog , namespace: :views do
scope_to :current_user
actions :index
scope :all, :default => true

 action_item only:[:index] do
  if params[:slug].present?
   question = Question.get_question(params[:slug])
   link_to "Back to Question dashboard", "/question/#{question.slug}"
  else
   link_to "Back to dashboard", "/dashboard"
  end
 end
 menu false

 DEFAULTS["active_admin_providers"].each do |provider|
  scope "#{provider}" do |detail|
    detail.where("question_view_logs.provider ilike ?","#{provider}")
  end
 end

 #column("Tenant") {|customer_detail| Tenant.where("id = ?",customer_detail.tenant_id ).first.name }


 index :title => 'Viewed customer details' do
    column("Question",:question) unless params[:slug].present?
    column("Provider") { |detail| detail.provider_name.capitalize }
    column("Viewed on", :viewed_at)
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
  end

  sidebar :filters, only: :index do
    render 'admin/filters/view_filters'
  end

  csv do
    column :question unless params[:slug].present?
    column('provider') { |detail| detail.provider_name.capitalize }
    column :viewed_at
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
  end

  controller do

     def scoped_collection
        params["slug"].blank? ? Question.fetch_all_view_users("view", current_user.id, params) : Question.fetch_view_users("view", params["slug"], params)
     end

    def apply_filtering(collection)
      @filters = Question.get_advanced_filter_collection(collection)
      Question.filtering_scopes.each do |scope|
        collection = collection.filter_by(scope, filter_params[scope], "view") unless filter_params[scope].blank?
      end
     return collection
    end

    def filter_params
      @filter_params = params[:view_logs] || {}
    end

  end

end


