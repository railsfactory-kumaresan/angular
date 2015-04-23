module QuestionVideoUploadService
  require 'RMagick'
  require 'transloadit'
	extend ActiveSupport::Concern
	included do
		protect_from_forgery :except => [:question_video_upload]
		def question_video_upload
			Dir.mkdir("#{ Rails.root }/public/data") unless File.exists?("#{ Rails.root }/public/data")
			name = dynamic_file_name_creation(params['Filename'], params["user_id"], params["id"])
			directory = "public/data"
			# create the file path
			path = File.join(directory, name)
			# write the file
			newparams = coerce(params)
			video = "/data/#{name}"
			File.open(path, "wb") { |f| f.write(newparams[:upload][:video].read) }
      file_format = video.split(//).last(3).join
      if ["jpg","jpeg","pjpeg","png","x-png","gif"].include?(file_format.to_s)
			image = Magick::Image.read(File.open("#{ Rails.root }/public/#{video}")).first
                        image.change_geometry!("500x300") { |cols, rows, img|
                         newimg = img.resize(cols, rows)
                         newimg.write("#{ Rails.root }/public/#{video}")
                                }
      end 
			warden.set_user current_user
			cookies["_session_id"] = params["session_secret"]
			render :json => { status: 200, preview_image: video }
		end

    protected
		
		def transloadit(url)
			@url = url.split("/").last
			if ["jpg", "png", "jpeg"].include?(url.split(".").last.to_s.downcase)
				attachment = Attachment.create(:image => File.open("#{Rails.public_path}/data/#{@url}"), :attachable_id => current_user.id,:attachable_type => "QuestionImage")
			else
				transloadit = Transloadit.new(
					:key    => ENV["TRANSLOADIT_KEY"],
					:secret =>  ENV["TRANSLOADIT_SECRET"]
				)
				assembly = transloadit.assembly(
					:template_id => ENV['TRANSLOADIT_TEMPLATE_ID'],
					:blocking => true
				)
				url_path = Rails.root.join("/data/#{ url }")
				response = assembly.submit! open("#{ Rails.root }/public/data/#{ @url }")
				if response.error?
					return nil
				else
					cleanup(@url)
					return response
				end
			end
		end

		private
		def coerce(params)
			if params[:upload].nil?
				h = Hash.new
				h[:upload] = Hash.new
				h[:upload][:video] = params['Filedata']
				h[:upload][:video].content_type = MIME::Types.type_for(h[:upload][:video].original_filename).to_s
				h
			else
				params
			end
		end

		def cleanup(url)
			File.delete("#{Rails.root}/public/data/#{url}") if File.exist?("#{Rails.root}/public/data/#{url}")
		end

		def dynamic_file_name_creation(file_name, user_id, id)
			file_name_without_extension = file_name.gsub( /.{3}$/, '' )
			file_extension = file_name.split(".").last
			name = file_name_without_extension+"#{ user_id }"+"_#{ id }"+".#{ file_extension }"
			return name
		end

	end
end