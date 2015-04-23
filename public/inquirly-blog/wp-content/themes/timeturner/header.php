<?php
/**
 * The header template file.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/
?><!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" <?php language_attributes(); ?>>
<![endif]-->
<!--[if !(IE 7) | !(IE 8)  ]><!-->
<html <?php language_attributes(); ?>>
<!--<![endif]-->
<head>
<?php global $timeturner_options;
foreach ($timeturner_options as $value) {
	if (isset($value['id']) && get_option( $value['id'] ) === FALSE && isset($value['std'])) {
		$$value['id'] = $value['std'];
	}
	elseif (isset($value['id'])) { $$value['id'] = get_option( $value['id'] ); }
} ?>
  <meta charset="<?php bloginfo( 'charset' ); ?>" /> 
  <meta name="viewport" content="width=device-width, minimumscale=1.0, maximum-scale=1.0" />  
  <title><?php wp_title( '|', true, 'right' ); ?></title>
<?php if ($timeturner_favicon_url != ''){ ?>
	<link rel="shortcut icon" href="<?php echo $timeturner_favicon_url; ?>" />
<?php } ?>
<?php wp_head(); ?>  
</head>
 
<body <?php body_class(); ?> id="wrapper">
<div><a href="#wrapper" class="scroll-top"></a></div>

<?php if ($timeturner_display_header_logo != 'Hide'){ ?>
<div id="header-logo">
  <div class="border-logo">
    <div class="background-logo">
    <?php if ($timeturner_logo_url != ''){ ?>
      <a href="<?php echo esc_url( home_url( '/' ) ); ?>"><img class="header-logo-img" src="<?php echo $timeturner_logo_url; ?>" alt="logo" /></a>
    <?php } else { ?>
      <a href="<?php echo esc_url( home_url( '/' ) ); ?>"><img class="header-logo-img" src="<?php echo get_template_directory_uri(); ?>/images/logo.png" alt="logo" /></a>
    <?php } ?> 
    </div>
  </div>
  <div class="background-pattern"> 
  </div>
  <div class="logo-inner-top-left-radius logo-inner-radius"></div>
  <div class="logo-inner-top-right-radius logo-inner-radius"></div>
  <div class="logo-inner-bottom-left-radius logo-inner-radius"></div>
  <div class="logo-inner-bottom-right-radius logo-inner-radius"></div>
  <div class="logo-outer-top-left-radius logo-outer-radius"></div>
  <div class="logo-outer-top-right-radius logo-outer-radius"></div>
  <div class="logo-outer-bottom-left-radius logo-outer-radius"></div>
  <div class="logo-outer-bottom-right-radius logo-outer-radius"></div>
</div>
<?php } ?>

<div id="wrapper-menu">
<div class="wrapper-menu-line">
<?php if ( has_nav_menu( 'header-menu' ) ) { ?>
  <div id="menu">
    <?php wp_nav_menu( array( 'menu_id'=>'nav', 'theme_location'=>'header-menu' ) );?>
  </div><?php } ?>
</div>
</div>  <!-- end of wrapper-menu -->
 
<div id="wrapper-header">
<div class="wrapper-bottom-line">
  <div id="header">
    <p class="site-title"><a href="<?php echo esc_url( home_url( '/' ) ); ?>"><?php bloginfo( 'name' ); ?></a></p>
    <div class="description-wrapper">
      <div class="description-hatching"></div>
      <div class="description-box">
        <p class="site-description"><?php bloginfo( 'description' ); ?></p>
        <div class="top-left-radius dark-radius"></div>
        <div class="top-right-radius dark-radius"></div>
        <div class="bottom-left-radius dark-radius"></div>
        <div class="bottom-right-radius dark-radius"></div>
      </div>
    </div>

<?php if ( is_home() ) { ?>
<?php if ( $timeturner_display_homepage_slideshow != 'Hide' ) { ?>  
<?php if ( dynamic_sidebar( 'sidebar-7' ) ) : else : ?>
    <div id="slideshow-main-wrapper">
      <div class="slideshow-background">
        <img src="<?php echo get_template_directory_uri(); ?>/images/slider1.jpg" class="cycloneslider-static" alt="slider" />
        <div class="slideshow-top-left-radius slideshow-radius"></div>
        <div class="slideshow-top-right-radius slideshow-radius"></div>
        <div class="slideshow-bottom-left-radius slideshow-radius"></div>
        <div class="slideshow-bottom-right-radius slideshow-radius"></div>
      </div>
    </div>
<?php endif; ?>
<?php } ?>
    
<?php timeturner_get_index_motto(); ?>
<?php } ?>
  </div>
</div>
</div>     <!-- end of wrapper-header -->