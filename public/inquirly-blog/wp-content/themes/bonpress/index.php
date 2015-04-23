<?php
get_header();

if ( option::get('intro_show') == 'on' ) {

	?><div id="welcome">

		<?php
		$avatar = trim(option::get('intro_avatar'));
		if ( !empty($avatar) ) {

			if ( simple_email_check($avatar) ) {

				echo get_avatar( $avatar, 95 );

			} else {

				echo '<img src="' . $avatar . '" />';

			}

		}
		?>

		<h2><?php echo option::get('intro_title'); ?></h2>
		<?php echo stripslashes(option::get('intro_content')); ?>
		<div class="clear"></div>

	</div><?php

}
?>

<div id="content">

	<?php
	if ( option::get('exclude_cats_home') != 'off' ) {
		if ( count(option::get('exclude_cats_home')) ) {
			$exclude_cats = implode(",-", (array) option::get('exclude_cats_home'));
			$exclude_cats = '-' . $exclude_cats;
			$args['cat'] = $exclude_cats;
		}
	}

	$args['paged'] = $paged;
	if ( count($args) >= 1 ) query_posts($args);

	get_template_part('loop');
	?>

</div>

<?php get_template_part('pagination'); ?>

<div class="clear"></div>

<?php get_footer(); ?>