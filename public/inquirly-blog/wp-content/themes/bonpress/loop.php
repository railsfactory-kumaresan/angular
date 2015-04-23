<?php
if ( have_posts() ) :

	while ( have_posts() ) :

		the_post();

		$show_title = option::get('display_title') == 'on';
		$show_title = 'Yes' == ($t=trim(get_post_meta(get_the_ID(), 'wpzoom_post_title', true))) ? true : ($t == 'No' ? false : $show_title);

		$show_readmore = option::get('display_readmore') == 'on';
		$show_readmore = 'Yes' == ($r=trim(get_post_meta(get_the_ID(), 'wpzoom_post_readmore', true))) ? true : ($r == 'No' ? false : $show_readmore);

		$title_url = trim(get_post_meta(get_the_ID(), 'wpzoom_post_url', true));

		?><div id="post-<?php the_ID(); ?>" <?php post_class(); ?>>

			<span class="post_icon"><a href="<?php the_permalink(); ?>" class="fade" title="<?php the_title_attribute(); ?>"><?php the_title(); ?></a></span>

			<?php if ( $show_title ) { ?><h2><a href="<?php if ( !empty($title_url) ) echo $title_url; else the_permalink(); ?>" title="<?php the_title_attribute(); ?>"><?php the_title(); ?></a></h2><?php } ?>

			<div class="entry">
				<?php if ( option::get('display_content') == 'Full Content' ) the_content(''); else the_excerpt(); ?>
			</div>

			<div class="meta clearfix">

				<?php
				if ( option::get('display_date') == 'on' ) { ?><span class="date"><?php the_date(); ?></span><?php }
				if ( option::get('display_comm_count') == 'on' ) { ?><span class="comments"><?php comments_popup_link( __('0 comments', 'wpzoom'), __('1 comment', 'wpzoom'), __('% comments', 'wpzoom'), '', __('Comments are Disabled', 'wpzoom') ); ?></span><?php }
				edit_post_link( __('Edit', 'wpzoom'), '<span>', '</span>');
				if ( $show_readmore ) { ?><a href="<?php the_permalink(); ?>" class="readmore fade"><?php _e('Read More', 'wpzoom'); ?></a><?php }
				?>

			</div>

		</div><!-- /.post --><?php

	endwhile;

else :

	?><p class="title"><?php _e('There are no posts', 'wpzoom'); ?></p><?php

endif;

wp_reset_query();
?>