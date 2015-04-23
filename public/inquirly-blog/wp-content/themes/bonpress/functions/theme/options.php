<?php return array(

/* Theme Admin Menu */
"menu" => array(
	array("id"   => "1",
				"name" => "General"),

	array("id"   => "2",
				"name" => "Homepage")
),

/* Theme Admin Options */
"id1" => array(
	array("type" => "preheader",
				"name" => "Theme Settings"),

		array("name"    => "Color Style",
					"desc"    => "Choose the style that you would like to use.",
					"id"      => "theme_style",
					"options" => array('Orange', 'Blue', 'Pink', 'Black'),
					"std"     => "Orange",
					"type"    => "select"),

		array("name" => "Logo Image",
					"desc" => "Upload a custom logo image for your site, or you can specify an image URL directly.",
					"id"   => "misc_logo_path",
					"std"  => "",
					"type" => "upload"),

		array("name" => "Favicon URL",
					"desc" => "Upload a favicon image (16&times;16px).",
					"id"   => "misc_favicon",
					"std"  => "",
					"type" => "upload"),

		array("name" => "Custom Feed URL",
					"desc" => "Example: <strong>http://feeds.feedburner.com/wpzoom</strong>",
					"id"   => "misc_feedburner",
					"std"  => "",
					"type" => "text"),

	array("type" => "preheader",
				"name" => "Global Posts Options"),

		array("name" => "Show Post Title",
					"desc" => "Can be overridden on a per-post basis by editing the post and modifying the <strong>Show post title</strong> option in the <strong>Custom Post Options</strong> box.",
					"id"   => "display_title",
					"std"  => "on",
					"type" => "checkbox"),

		array("name"    => "Posts Display Type",
					"desc"    => "Number of posts displayed on homepage can be changed <a href=\"options-reading.php\" target=\"_blank\">here</a>.",
					"id"      => "display_content",
					"options" => array('Excerpt', 'Full Content'),
					"std"     => "Full Content",
					"type"    => "select"),

		array("name" => "Excerpt Length",
					"desc" => "Default: <strong>50</strong> (words)",
					"id"   => "excerpt_length",
					"std"  => "50",
					"type" => "text"),

		array("name" => "Show Date/Time",
					"desc" => "<strong>Date/Time format</strong> can be changed <a href='options-general.php' target='_blank'>here</a>.",
					"id"   => "display_date",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Show Comments Count",
					"id"   => "display_comm_count",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Show Read More Button",
					"desc" => "Can be overridden on a per-post basis by editing the post and modifying the <strong>Show &ldquo;<em>Read More</em>&rdquo; button</strong> option in the <strong>Custom Post Options</strong> box.",
					"id"   => "display_readmore",
					"std"  => "on",
					"type" => "checkbox"),

	array("type" => "preheader",
				"name" => "Single Post Options"),

		array("name" => "Show Date/Time",
					"desc" => "<strong>Date/Time format</strong> can be changed <a href='options-general.php' target='_blank'>here</a>.",
					"id"   => "post_date",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Show Comments Count",
					"id"   => "post_comm_count",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Show Tags",
					"id"   => "post_tags",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Show Trackbacks",
					"id"   => "post_trackbacks",
					"std"  => "off",
					"type" => "checkbox")
),

"id2" => array(
	array("type" => "preheader",
				"name" => "Homepage Settings"),

		array("name" => "Exclude Categories on Homepage",
					"desc" => "Choose the categories which should be excluded from the main Loop on the homepage.<br/> <em>Press CTRL or CMD key to select/deselect multiple categories.</em>",
					"id"   => "exclude_cats_home",
					"std"  => "",
					"type" => "select-category-multi"),

	array("type" => "preheader",
				"name" => "Welcome Message"),

		array("name" => "Show Welcome Message on Homepage",
					"id"   => "intro_show",
					"std"  => "on",
					"type" => "checkbox"),

		array("name" => "Message Title",
					"desc" => "Example: <strong>Welcome to our website!</strong>",
					"id"   => "intro_title",
					"std"  => "Welcome to our website!",
					"type" => "text"),

		array("name" => "Message Content",
					"desc" => "Add a short description about your website or agency.",
					"id"   => "intro_content",
					"type" => "textarea"),

		array("name" => "Profile Picture",
					"desc" => "You can upload your own picture or specify your <strong>Gravatar</strong> email in this field.",
					"id"   => "intro_avatar",
					"type" => "upload")
)

/* end return */);