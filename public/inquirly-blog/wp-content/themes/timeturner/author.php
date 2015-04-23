<?php
/**
 * The author archive template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
get_header(); ?>

<div id="wrapper-content">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
<?php if ( have_posts() ) : ?>
<?php the_post(); ?>
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h1 class="content-headline"><?php printf( __( 'Author Archives: %s', 'timeturner' ), '<span class="vcard">' . get_the_author() . '</span>' ); ?></h1>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
        <?php rewind_posts(); ?>
        
        <?php if ( get_the_author_meta( 'description' ) ) : ?>
			  <div class="author-info">
				<div class="author-avatar">
					<?php echo get_avatar( get_the_author_meta( 'user_email' ), apply_filters( 'timeturner_author_bio_avatar_size', 60 ) ); ?>
				</div>
				<div class="author-description">
					<h2><?php printf( __( 'About %s', 'timeturner' ), get_the_author() ); ?></h2>
					<p><?php the_author_meta( 'description' ); ?></p>
				</div>
			  </div>
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