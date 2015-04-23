<?php
/**
 * The category archive template file.
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
        <h1 class="content-headline"><?php single_cat_title(); ?></h1>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
    <?php if ( category_description() ) : ?>
		  <div class="archive-meta"><?php echo category_description(); ?></div>
		<?php endif; ?>
    
<?php $args = array(
	'post_type' => 'post',
	'post_status' => 'publish'
);
$query = new WP_Query( $args ); 
                
while (have_posts()) : the_post(); ?> 
<?php get_template_part( 'content', 'archives' ); ?>
<?php endwhile; endif; ?>
<?php timeturner_content_nav( 'nav-below' ); ?>
    </div> <!-- end of content -->
<?php get_sidebar(); ?>
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->
<?php get_footer(); ?>