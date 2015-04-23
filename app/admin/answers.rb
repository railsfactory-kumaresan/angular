include ActiveAdmin

ActiveAdmin.register Answer , namespace: :word do
  actions :index
  scope :all, :default => true

 action_item only:[:index] do
   question = Question.get_question(params[:slug])
   link_to "Back to Question dashboard", "/question/#{question.slug}"
 end
index :title => 'List of Customers' do
    column('Comment') { |detail| detail.comments.blank? ? detail.free_text : detail.comments } if params[:option].blank?
    column('provider') { |detail| detail.provider_name.capitalize }
    column("Responded on", :responded_at)
    column("Name", :name)
    column("Email",:email)
    column("Mobile",:mobile)
    column("Country", :country)
    column("State",:state)
    column("Area",:area)
    column("City",:city)
    column("Age",:age)
    column('gender') { |detail| detail.gender.capitalize if detail.gender}
    column("Tenant",:tenant_name)
    column("Custom Field",:custom_field)
  end
# config.filters = false
 menu false

   csv do
    column('comments') { |detail| detail.comments.blank? ? detail.free_text : detail.comments } if params[:option].blank?
    column('provider') { |detail| detail.provider_name.capitalize }
    column :responded_at
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

 DEFAULTS["active_admin_providers"].each do |provider|
  scope "#{provider}" do |detail|
    detail.where("answers.provider ilike ? ","#{provider}")
  end
 end

  sidebar :filters, only: :index do
    render 'admin/filters/word_filters'
  end

  controller do

    def scoped_collection
			Question.fetch_answerd_customers(params[:slug], params[:option])
    end

    # Overrides the Ransack search methods and uses default AR scopes
    def apply_filtering(collection)
      @filters = Question.get_advanced_filter_collection(collection)
      Question.filtering_scopes.each do |scope|
        collection = collection.filter_by(scope, filter_params[scope], "answer") unless filter_params[scope].blank?
      end
     return collection
    end

    def filter_params
      @filter_params = params[:answer_details] || {}
    end

  end
end
