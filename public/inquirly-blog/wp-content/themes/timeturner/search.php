<?php
/**
 * The search results template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
get_header(); ?>

<div id="wrapper-content">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
<?php if ( have_posts() ) : ?>
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h1 class="content-headline"><?php printf( __( 'Search Results for: %s', 'timeturner' ), '<span>' . get_search_query() . '</span>' ); ?></h1>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
<p class="number-of-results"><?php _e( 'Number of Results: ', 'timeturner' ); ?><?php echo $wp_query->found_posts; ?></p>

<?php $args = array(
	'post_status' => 'publish'
);
$query = new WP_Query( $args ); 
                
while (have_posts()) : the_post(); ?> 
<?php get_template_part( 'content', 'archives' ); ?>
<?php endwhile; ?>

<?php if ( $wp_query->max_num_pages > 1 ) : ?>
		<div class="navigation" role="navigation">
			<h3 class="navigation-headline section-heading"><?php _e( 'Search results navigation', 'timeturner' ); ?></h3>
			<p class="nav-next"><?php previous_posts_link( __( '<span class="meta-nav">&larr;</span> Previous results', 'timeturner' ) ); ?></p>
      <p class="nav-previous"><?php next_posts_link( __( 'Next results <span class="meta-nav">&rarr;</span>', 'timeturner' ) ); ?></p>
		</div>
<?php endif; ?>
    </div> <!-- end of content -->
      
      <?php else : ?>
  <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h1 class="content-headline"><?php _e( 'Nothing Found', 'timeturner' ); ?></h1>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
      <p><?php _e( 'Sorry, but nothing matched your search criteria. Please try again with some different keywords.', 'timeturner' ); ?></p>
      <?php get_search_form(); ?>
    </div> <!-- end of content -->
<?php endif; ?>
<?php get_sidebar(); ?>
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->
<?php get_footer(); ?>