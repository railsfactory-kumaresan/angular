object false

	node :header do
		{ :status => 200 }
	end

	node :body do
		{ :view_count => @view_count.first, :response_count => @response_count.flatten.first, :label => @x_axis_label }
	end
