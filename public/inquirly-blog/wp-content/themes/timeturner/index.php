<?php
/**
 * The main template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
get_header(); ?>

<?php if ($timeturner_display_about_section != 'Hide'){ ?>
<div id="wrapper-about">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h2 class="about-headline"><?php echo $timeturner_about_headline; ?></h2>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    
    <div class="about-boxes-wrapper">
<?php if ( dynamic_sidebar( 'sidebar-8' ) ) : else : ?>
      <div class="about-box">
      <div class="about-box-inner">
      <div class="about-box-content">
        <h3><?php _e( 'How to edit these boxes?' , 'timeturner' ); ?></h3>
        <img src="<?php echo get_template_directory_uri(); ?>/images/image-1.jpg" alt="image" />
        <p><?php _e( 'For editing these boxes, go to the Appearance > Widgets menu and insert as many Text widgets as you like into "About Section boxes on homepage" widget area.' , 'timeturner' ); ?></p>
        <a class="read-more-button" href="#nogo"><?php _e( 'READ MORE' , 'timeturner' ); ?></a>
      </div>
      </div>
        <div class="about-top-left-radius about-radius"></div>
        <div class="about-top-right-radius about-radius"></div>
        <div class="about-bottom-left-radius about-radius"></div>
        <div class="about-bottom-right-radius about-radius"></div>
      </div>
      
      <div class="about-box">
      <div class="about-box-inner">
      <div class="about-box-content">
        <h3><?php _e( 'Useful shortcodes' , 'timeturner' ); ?></h3>
        <img src="<?php echo get_template_directory_uri(); ?>/images/image-1.jpg" alt="image" />
        <p><?php _e( 'To insert the "Read more" button anywhere you like, you can use this useful custom shortcode:<br />[more-button link="<em>URL address</em>"]<em>READ MORE</em>[/more-button]' , 'timeturner' ); ?></p>
        <a class="read-more-button" href="#nogo"><?php _e( 'READ MORE' , 'timeturner' ); ?></a>
      </div>
      </div>
        <div class="about-top-left-radius about-radius"></div>
        <div class="about-top-right-radius about-radius"></div>
        <div class="about-bottom-left-radius about-radius"></div>
        <div class="about-bottom-right-radius about-radius"></div>
      </div>
      
      <div class="about-box">
      <div class="about-box-inner">
      <div class="about-box-content">
        <h3><?php _e( 'How to remove this area?' , 'timeturner' ); ?></h3>
        <img src="<?php echo get_template_directory_uri(); ?>/images/image-1.jpg" alt="image" />
        <p><?php _e( 'If you do not want to display this area, go to the "Theme Options" panel. In "Homepage Settings", you can hide this area. Same way you can rename or hide the other areas, too.' , 'timeturner' ); ?></p>
        <a class="read-more-button" href="#nogo"><?php _e( 'READ MORE' , 'timeturner' ); ?></a>
      </div>
      </div>
        <div class="about-top-left-radius about-radius"></div>
        <div class="about-top-right-radius about-radius"></div>
        <div class="about-bottom-left-radius about-radius"></div>
        <div class="about-bottom-right-radius about-radius"></div>
      </div>
<?php endif; ?>      
    </div>
    
    </div>
</div>
</div>
</div>     <!-- end of wrapper-about -->
<?php } ?>

<?php if ($timeturner_display_portfolio_section != 'Hide'){ ?>
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
  'showposts' => $timeturner_portfolio_items,
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

<?php } else { ?>
<div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 1' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
      
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 2' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
      
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 3' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
    
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 4' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
      
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 5' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
      
      <div class="portfolio-box">
      <div class="portfolio-content">
        <a class="portfolio-link" href="#nogo"><img src="<?php echo get_template_directory_uri(); ?>/images/image-2.jpg" alt="image" /></a>
        <h3><a class="portfolio-link" href="#nogo"><?php _e( 'Portfolio Item 6' , 'timeturner' ); ?></a></h3>
      </div>
        <div class="portfolio-top-left-radius portfolio-radius"></div>
        <div class="portfolio-top-right-radius portfolio-radius"></div>
        <div class="portfolio-bottom-left-radius portfolio-radius"></div>
        <div class="portfolio-bottom-right-radius portfolio-radius"></div>
      </div>
<?php } ?> 

  </div>
</div>
</div>
</div>
</div>     <!-- end of wrapper-portfolio -->
<?php } ?>

<?php if ($timeturner_display_blog_section != 'Hide'){ ?>
<div id="wrapper-blog">
<div class="wrapper-bottom-line">
<div class="wrapper-top-line">
  <div class="container">
    <div class="headline-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <h2 class="blog-headline"><?php echo $timeturner_blog_headline; ?></h2>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>
    <div id="content">
<?php $args = array(  
	'post_type' => 'post',
	'post_status' => 'publish'
);
$query = new WP_Query( $args ); 
                
if (have_posts()) : while (have_posts()) : the_post(); ?>
      <div <?php post_class('post-entry'); ?>>
        <h3 class="post-entry-headline"><a href="<?php echo get_permalink(); ?>"><?php the_title(); ?></a></h3>
        <p class="post-info"><?php _e( 'Author', 'timeturner' ); ?>: <?php the_author_posts_link(); ?> | <?php _e( 'Category', 'timeturner' ); ?>: <?php the_category(', ') ?><?php the_tags( __( ' | Tags: ', 'timeturner' ), ', ', '' ); ?></p>
        <div class="post-entry-content">
          <?php if ( has_post_thumbnail() ) : ?>
          <div class="post-thumbnail"><a href="<?php echo get_permalink(); ?>"><?php the_post_thumbnail(); ?></a>
            <div class="blog-top-left-radius blog-radius"></div>
            <div class="blog-top-right-radius blog-radius"></div>
            <div class="blog-bottom-left-radius blog-radius"></div>
            <div class="blog-bottom-right-radius blog-radius"></div>
          </div>
          <?php endif; ?>
          <div class="post-intro"><?php global $more; $more = 0; ?><?php the_content(); ?></div>
          <p class="post-data"><?php _e( 'Published: ', 'timeturner' ); ?><a href="<?php echo get_permalink(); ?>"><?php the_time( 'd. m. Y' ) ?></a><?php if ( comments_open() ) : ?><?php _e( ' | Comments: ', 'timeturner' ); ?><a class="article-comments" href="<?php comments_link(); ?>"><?php comments_number( '0', '1', '%' ); ?></a><?php endif; ?></p>
        </div>
      </div>
<?php endwhile; endif; ?>
<?php timeturner_content_nav( 'nav-below' ); ?>
    </div> <!-- end of content -->

<?php get_sidebar( 'index' ); ?>
  </div>
</div>
</div>
</div>     <!-- end of wrapper-blog -->
<?php } ?>
<?php get_footer(); ?>