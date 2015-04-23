<?php
/**
 * Template Name: Portfolio
 * The template file for displaying page with Portfolio Items.
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

    </div> <!-- end of content -->
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->

<div id="wrapper-portfolio">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h2 class="portfolio-headline"><?php echo $timeturner_portfolio_headline; ?></h2>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    
    <div class="portfolio-boxes-wrapper">
<?php if ( $timeturner_portfolio_category != '0' ) { ?>
<?php $args1 = array(
  'cat' => $timeturner_portfolio_category,
  'showposts' => '-1',
	'post_type' => 'post',
	'post_status' => 'publish'
);
$my_query = new WP_Query( $args1 ); 
                
if ($my_query->have_posts()) : while ($my_query->have_posts()) : $my_query->the_post(); ?>
<?php if ( has_post_thumbnail() ) : ?>
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="<?php echo get_permalink(); ?>"><?php the_post_thumbnail( 'portfolio-thumb' ); ?></a>
        <h3><a class="portfolio-link" href="<?php echo get_permalink(); ?>"><?php the_title(); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
<?php endif; ?>
<?php endwhile; endif; ?>

<?php } ?> 

  </div>
</div>
</div>
</div>
</div>     <!-- end of wrapper-portfolio -->
<?php get_footer(); ?>