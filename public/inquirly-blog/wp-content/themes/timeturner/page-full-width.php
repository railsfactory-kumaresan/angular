<?php
/**
 * Template Name: Full Width
 * The template file for pages without right sidebar.
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
    <div id="content" class="full-width">
<?php timeturner_get_display_image_page(); ?>
<?php the_content( 'Continue reading' ); ?>
<?php endwhile; endif; ?>

<?php comments_template( '', true ); ?>
    </div> <!-- end of content -->
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->
<?php get_footer(); ?>