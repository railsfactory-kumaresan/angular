<?php

add_action('admin_menu', 'wpzoom_options_box');

function wpzoom_options_box() {
 	add_meta_box('wpzoom_post_template', 'Custom Post Options', 'wpzoom_post_options', 'post', 'side', 'high');
  	}

// Regular Posts Options
function wpzoom_post_options() {

	global $post;

	?><fieldset>

		<div>

			<p>
				<label for="wpzoom_post_title">Show post title:</label> 
				<select name="wpzoom_post_title" id="wpzoom_post_title">
					<option<?php selected( get_post_meta($post->ID, 'wpzoom_post_title', true), 'Yes' ); ?>>Yes</option>
					<option<?php selected( get_post_meta($post->ID, 'wpzoom_post_title', true), 'No' ); ?>>No</option>
 				</select>
			</p>

			<p>
				<label for="wpzoom_post_readmore">Show &ldquo;<em>Read More</em>&rdquo; button:</label> 
				<select name="wpzoom_post_readmore" id="wpzoom_post_readmore">
					<option<?php selected( get_post_meta($post->ID, 'wpzoom_post_readmore', true), 'Yes' ); ?>>Yes</option>
					<option<?php selected( get_post_meta($post->ID, 'wpzoom_post_readmore', true), 'No' ); ?>>No</option>
 				</select>
			</p>

			<p>
				<label>URL to redirect title <em>(optional)</em>:</label><br /> 
				<input style="width:100%" type="text" name="wpzoom_post_url" id="wpzoom_post_url" value="<?php echo get_post_meta($post->ID, 'wpzoom_post_url', true); ?>" /></label>
 			</p>

  	</div>

	</fieldset><?php

}

add_action('save_post', 'custom_add_save');

function custom_add_save($postID){

global $meta_box;
 
	// called after a post or page is saved
	if($parent_id = wp_is_post_revision($postID))
	{
	  $postID = $parent_id;
	}

	if ($_POST['save'] || $_POST['publish']) {
 	update_custom_meta($postID, $_POST['wpzoom_post_title'], 'wpzoom_post_title');
 	update_custom_meta($postID, $_POST['wpzoom_post_readmore'], 'wpzoom_post_readmore');
 	update_custom_meta($postID, $_POST['wpzoom_post_url'], 'wpzoom_post_url');
	}
}

function update_custom_meta($postID, $newvalue, $field_name) {
// To create new meta
if(!get_post_meta($postID, $field_name)){
add_post_meta($postID, $field_name, $newvalue);
}else{
// or to update existing meta
update_post_meta($postID, $field_name, $newvalue);
}
}

?>