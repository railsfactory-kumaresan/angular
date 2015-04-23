<?php get_header(); ?>

<div id="heading">

	<?php if ( have_posts() ) the_post(); ?>

	<h1><?php _e('Search Results for', 'wpzoom'); ?> <strong>"<?php the_search_query(); ?>"</strong></h1>

</div>

<div class="clear"></div>

<?php rewind_posts(); ?>

<div id="content">

	<?php get_template_part('loop'); ?>

</div>

<?php get_template_part('pagination'); ?>

<div class="clear"></div>

<?php get_footer(); ?>