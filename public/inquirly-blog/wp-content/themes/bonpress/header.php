<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>
<head>

	<title><?php ui::title(); ?></title>
	<meta http-equiv="content-type" content="<?php bloginfo('html_type'); ?>; charset=<?php bloginfo('charset'); ?>" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

 	<meta name="viewport" content="width=device-width, initial-scale=1.0" />

 	<link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />
 	<link href='http://fonts.googleapis.com/css?family=Josefin+Slab:400,600' rel='stylesheet' type='text/css'>
 	<link rel="stylesheet" type="text/css" href="<?php echo get_stylesheet_uri(); ?>" media="screen" />

 	<?php wp_head(); ?>

</head>

<body <?php body_class(); ?>>

	<div class="wrapper">

		<div id="aside">

			<div class="gig">
 

				<div id="logo">
					<?php if (!option::get('misc_logo_path')) { echo "<h1>"; } ?>
					
					<a href="<?php bloginfo('url'); ?>" title="<?php bloginfo('description'); ?>">
						<?php if (!option::get('misc_logo_path')) { bloginfo('name'); } else { ?>
							<img src="<?php echo ui::logo(); ?>" alt="<?php bloginfo('name'); ?>" />
						<?php } ?>
					</a>
					
					<?php if (!option::get('misc_logo_path')) { echo "</h1>"; } ?>
				
				</div><!-- / #logo -->
 

				<div id="menu">
					<?php wp_nav_menu( array( 'container' => 'menu', 'container_class' => '', 'menu_class' => 'dropdown sf-vertical', 'menu_id' => 'mainmenu', 'sort_column' => 'menu_order', 'theme_location' => 'primary' ) ); ?>
				</div>

			</div>

			<div class="clear"></div>

			<?php get_sidebar(); ?>

		</div>

		<div id="main">