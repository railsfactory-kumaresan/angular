module ActiveAdmin
  module Views
    class PaginatedCollection
      def build_pagination_with_formats(options)
        div :id => "index_footer" do
          build_pagination
          div(page_entries_info(options).html_safe, :class => "pagination_information")
          build_download_format_links([:csv]) unless @download_links == false
        end
      end
    end
  end
end

