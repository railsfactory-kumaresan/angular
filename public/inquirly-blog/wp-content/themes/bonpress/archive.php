<?php get_header(); ?>

<div id="heading">

	<?php if ( have_posts() ) the_post(); ?>

	<h1><?php
		/* category archive */ if ( is_category() ) printf( __('Archive for category: <strong>%s</strong>', 'wpzoom'), single_cat_title('', false) );
		/* tag archive */ elseif ( is_tag() ) printf( __('Post Tagged with: <strong>%s</strong>', 'wpzoom'), single_tag_title('', false) );
		/* day/month/year archive */ elseif ( is_day() || is_month() || is_year() ) printf( __('Archive for <strong>%s</strong>', 'wpzoom'), get_the_time( is_day() ? 'F jS, Y' : ( is_month() ? 'F, Y' : 'Y' ) ) );
		/* author archive */ elseif ( is_author() ) printf( __('Articles by: <strong>%s</strong>', 'wpzoom'), '<a class="url fn n" href="' . get_author_posts_url( get_the_author_meta( 'ID' ) ) . '" title="' . esc_attr( get_the_author() ) . '" rel="me">' . get_the_author() . '</a>' );
		/* paged archive */ elseif ( isset($_GET['paged']) && !empty($_GET['paged']) ) _e('Archives', 'wpzoom');
		/* home page */ elseif ( is_front_page() ) _e('Recent Posts', 'wpzoom');
	?></h1>

</div>

<div class="clear"></div>

<?php rewind_posts(); ?>

<div id="content">

	<?php get_template_part('loop'); ?>

</div>

<?php get_template_part('pagination'); ?>

<div class="clear"></div>

<?php get_footer(); ?>