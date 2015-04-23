<?php
/**
 * The template for displaying posts in the Quote post format
 *
 * @since 1.0.0
 */
$bavotasan_theme_options = bavotasan_theme_options();
?>
	<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
		<div class="row">
			<div class="col-md-12">
			    <i class="icon-quote-left quote"></i>
			    <div class="entry-content">
				    <?php the_content( __( 'Read more &rarr;', 'ward' ) ); ?>
			    </div><!-- .entry-content -->

			    <?php get_template_part( 'content', 'footer' ); ?>
			</div>
	    </div>
	</article>