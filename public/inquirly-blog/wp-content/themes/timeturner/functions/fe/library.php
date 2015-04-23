<?php 
/**
 * Library of Theme options functions.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
?>
<?php global $timeturner_options;
foreach ($timeturner_options as $value) {
	if (isset($value['id']) && get_option( $value['id'] ) === FALSE && isset($value['std'])) {
		$$value['id'] = $value['std'];
	}
	elseif (isset($value['id'])) { $$value['id'] = get_option( $value['id'] ); }
} ?>
<?php  

// Display featured images on single posts
function timeturner_get_display_image_post() { 
		if (get_option('timeturner_display_image_post') == '' || get_option('timeturner_display_image_post') == 'Display') { ?>
		<?php if ( has_post_thumbnail() ) : ?>
      <?php the_post_thumbnail(); ?>
    <?php endif; ?>
<?php } 
}

// Display featured images on pages
function timeturner_get_display_image_page() { 
		if (get_option('timeturner_display_image_page') == '' || get_option('timeturner_display_image_page') == 'Display') { ?>
		<?php if ( has_post_thumbnail() ) : ?>
      <?php the_post_thumbnail(); ?>
    <?php endif; ?>
<?php } 
}

// Display the Date on posts
function timeturner_display_date_post () { 
	if (get_option('timeturner_display_date_post') == '' || get_option('timeturner_display_date_post') == 'Display'){ ?>
	<?php _e('<strong>Posted</strong>: ', 'timeturner'); ?><?php the_time( 'd. m. Y' ) ?>
	<?php }
  if (get_option('timeturner_display_author_post') == '' || get_option('timeturner_display_author_post') == 'Display' && get_option('timeturner_display_date_post') == 'Display') { ?>
		<?php _e(' | ', 'timeturner'); ?>
<?php }
}

// Display Categories on posts
function timeturner_display_category_post() {
	if (is_single() && (get_option('timeturner_display_categories_post') == '' || get_option('timeturner_display_categories_post') == 'Display')) { ?>	
		<?php _e('<strong>Category</strong>: ', 'timeturner'); ?><?php the_category(', ') ?>
	<?php } // end 
}

// Display Author on post
function timeturner_get_author_post() { 
		if (get_option('timeturner_display_author_post') == '' || get_option('timeturner_display_author_post') == 'Display') { ?>
		<?php _e('<strong>Author</strong>: ', 'timeturner'); ?><?php the_author_posts_link(); ?>
<?php }
    if (is_single() && (get_option('timeturner_display_categories_post') == '' || get_option('timeturner_display_categories_post') == 'Display' && get_option('timeturner_display_author_post') == 'Display')) { ?>	
		<?php _e(' | ', 'timeturner'); ?>
	<?php } 
  if (is_single() && (get_option('timeturner_display_categories_post') == 'Display' && get_option('timeturner_display_author_post') == 'Hide' && get_option('timeturner_display_date_post') == 'Display')) { ?>	
		<?php _e(' | ', 'timeturner'); ?>
	<?php } 
}

// Index headline motto
function timeturner_get_index_motto() { 
		$index_motto = get_option('timeturner_index_motto');
    if ($index_motto != '') { ?>
    <?php _e('<h1 class="header-motto">', 'timeturner'); ?><?php echo $index_motto; ?><?php _e('</h1>', 'timeturner'); ?> 
    <?php } 
} 
?>