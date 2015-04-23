<?php
/**
 * The template for displaying content of search/archives.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
?>
      <div <?php post_class('post-entry'); ?>>
        <h2 class="post-entry-headline"><a href="<?php echo get_permalink(); ?>"><?php the_title(); ?></a></h2>
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