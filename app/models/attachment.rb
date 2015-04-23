class Attachment < ActiveRecord::Base
  #attr_accessible :image, :attachable_type, :attachable_id
  belongs_to :attachable, :polymorphic => true
  has_attached_file :image, :styles => {:thumb => "116x97", :medium => "100x100", :large => "600X400"},
                    :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png", "image/pjpeg", "image/x-png"],
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/assets/questions/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :image

#comment for remove the restrictions for photo_count
  def self.create_file_attachment(params,q)
    #~ if q.user.check_action_privilege('video_photo_count')
    que = params[:question]
    Attachment.create(:image => que[:image], :attachable_id => q.id,:attachable_type => "Question") if que && que[:image].present?
   #~ end
  end

  def self.attach_user_profile(user,image)
    u_res = user.present?
    user.attachment.destroy if u_res && user.attachment.present?
    user.create_attachment(:image => open("#{image}")) if u_res
  end
end
