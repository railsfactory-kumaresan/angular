<div class="navigation">

	<?php
	if ( function_exists('wp_pagenavi') ) {

		wp_pagenavi();

	} else {

		?><div class="floatleft"><?php next_posts_link(''); ?></div>
		<div class="floatright"><?php previous_posts_link(''); ?></div><?php

	}
	?>

</div>