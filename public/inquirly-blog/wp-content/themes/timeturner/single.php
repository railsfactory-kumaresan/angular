<?php
/**
 * The post template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
get_header(); ?>

<div id="wrapper-content">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
<?php if (have_posts()) : while (have_posts()) : the_post(); ?>
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h1 class="content-headline"><?php the_title(); ?></h1>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
<p class="post-meta"><?php timeturner_display_date_post(); ?> <?php timeturner_get_author_post(); ?> <?php timeturner_display_category_post(); ?></p>
<?php timeturner_get_display_image_post(); ?>

<?php the_content( 'Continue reading' ); ?>

<?php wp_link_pages( array( 'before' => '<p class="page-link"><span>' . __( 'Pages:', 'timeturner' ) . '</span>', 'after' => '</p>' ) ); ?>
<?php endwhile; endif; ?>

<?php if (($timeturner_next_preview_post == '') || ($timeturner_next_preview_post == 'Display')) :  timeturner_prev_next('timeturner-post-nav');  endif; ?>

<?php comments_template( '', true ); ?>
    </div> <!-- end of content -->
<?php get_sidebar(); ?>
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->
<?php get_footer(); ?>