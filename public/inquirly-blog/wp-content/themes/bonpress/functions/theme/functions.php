<?php

/* Register Thumbnails Size 
================================== */

if ( function_exists( 'add_image_size' ) ) {

    /* Recent Posts Widget */
    add_image_size( 'recent-widget', 75, 50, true );

}

/* Register Custom Menu
==================================== */

register_nav_menu('primary', 'Main Menu');



/* Add Support For Post Formats
==================================== */

add_theme_support( 'post-formats', array( 'audio', 'image', 'video', 'link', 'quote' ) );



/* Reset default WP styling for [gallery] shortcode
===================================================== */

add_filter('gallery_style', create_function('$a', 'return "<div class=\'gallery\'>";'));



/* Add Support for Shortcodes in Excerpt & Widgets
================================================================ */

add_filter('the_excerpt', 'shortcode_unautop');
add_filter('the_excerpt', 'do_shortcode');
add_filter('widget_text', 'shortcode_unautop');
add_filter('widget_text', 'do_shortcode');



/* Add support for Custom Background
==================================== */

add_theme_support( 'custom-background' );  
 

/* Remove [caption] in-line styling
==================================== */

add_shortcode('wp_caption', 'fixed_img_caption_shortcode');
add_shortcode('caption', 'fixed_img_caption_shortcode');
function fixed_img_caption_shortcode($attr, $content = null) {
	// Allow plugins/themes to override the default caption template.
	$output = apply_filters('img_caption_shortcode', '', $attr, $content);
	if ( $output != '' ) return $output;
	extract(shortcode_atts(array(
		'id'=> '',
		'align'	=> 'alignnone',
		'width'	=> '',
		'caption' => ''), $attr));
	if ( 1 > (int) $width || empty($caption) )
	return $content;
	if ( $id ) $id = 'id="' . esc_attr($id) . '" ';
	return '<div ' . $id . 'class="wp-caption ' . esc_attr($align)
	. '">'
	. do_shortcode( $content ) . '<p class="wp-caption-text">'
	. $caption . '</p></div>';
}



/* Function that allows to display only exact count of comments, without trackbacks
======================================================================================== */

function comment_count( $count ) {
	if ( ! is_admin() ) {
		global $id;
		$get_comments = get_comments('post_id=' . $id);
		$comments_by_type = &separate_comments($get_comments);
 		return count($comments_by_type['comment']);
	} else {
		return $count;
	}
}
add_filter('get_comments_number', 'comment_count', 0);



/* Default Excerpt Length
==================================== */

function new_excerpt_length($length) {
	return (int) get_option("wpzoom_excerpt") ? (int) get_option("wpzoom_excerpt") : 50;
}
add_filter('excerpt_length', 'new_excerpt_length');



/* Email validation
==================================== */

function simple_email_check($email) {
	// First, we check that there's one @ symbol, and that the lengths are right
	if (!ereg("^[^@]{1,64}@[^@]{1,255}$", $email)) {
		// Email invalid because wrong number of characters in one section, or wrong number of @ symbols.
		return false;
	}

	return true;
}



/* Comments Custom Template
==================================== */

function mytheme_comment($comment, $args, $depth) {
   $GLOBALS['comment'] = $comment; ?>
   <li <?php comment_class(); ?> id="li-comment-<?php comment_ID() ?>">
	<div id="comment-<?php comment_ID(); ?>" class="commbody">
	<div class="commleft">
		  <div class="comment-author vcard">
			 <?php echo get_avatar($comment,$size='60' ); ?>

			 <?php printf(__('<cite class="fn">%s</cite>'), get_comment_author_link()) ?>
		  </div>
 
		  <div class="comment-meta commentmetadata">
			<?php _e('on', 'wpzoom'); ?> <a href="<?php echo htmlspecialchars( get_comment_link( $comment->comment_ID ) ) ?>"><?php printf(__('%1$s <br/> '), get_comment_date('M d, Y'),  get_comment_time()) ?></a>
			<?php _e('at', 'wpzoom'); ?> <a href="<?php echo htmlspecialchars( get_comment_link( $comment->comment_ID ) ) ?>"><?php printf(__('%2$s'), get_comment_date(),  get_comment_time()) ?></a>
			
			
			<?php edit_comment_link(__('{Edit}'),'  ','') ?></div>
      </div>

      <?php comment_text() ?>
		 <?php if ($comment->comment_approved == '0') : ?>
			 <em><?php _e('Your comment is awaiting moderation.', 'wpzoom') ?></em>
			 <br />
		  <?php endif; ?>
      <div class="reply">
         <?php comment_reply_link(array_merge( $args, array('depth' => $depth, 'max_depth' => $args['max_depth']))) ?>
      </div>
      <div class="clear"></div>
     </div>
<?php }

 
?>