<?php
/**
 * Headerdata of Theme options.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/  
global $timeturner_options;
foreach ($timeturner_options as $value) {
	if (isset($value['id']) && get_option( $value['id'] ) === FALSE && isset($value['std'])) {
		$$value['id'] = $value['std'];
	}
	elseif (isset($value['id'])) { $$value['id'] = get_option( $value['id'] ); }
}

// additional js and css
if(	!is_admin()){
function timeturner_fonts_include () {
// Google Fonts
$bodyfont = get_option('timeturner_body_google_fonts');
$headingfont = get_option('timeturner_headings_google_fonts');
$descriptionfont = get_option('timeturner_description_google_fonts');
$headlinefont = get_option('timeturner_headline_google_fonts');
$postentryfont = get_option('timeturner_postentry_google_fonts');
$sidebarfont = get_option('timeturner_sidebar_google_fonts');
$mottofont = get_option('timeturner_motto_google_fonts');
$menufont = get_option('timeturner_menu_google_fonts');

$fonturl = "http://fonts.googleapis.com/css?family=";

$bodyfonturl = $fonturl.$bodyfont;
$headingfonturl = $fonturl.$headingfont;
$descriptionfonturl = $fonturl.$descriptionfont;
$headlinefonturl = $fonturl.$headlinefont;
$postentryfonturl = $fonturl.$postentryfont;
$sidebarfonturl = $fonturl.$sidebarfont;
$mottofonturl = $fonturl.$mottofont;
$menufonturl = $fonturl.$menufont;
	// Google Fonts
     if ($bodyfont != 'default' && $bodyfont != ''){
      wp_enqueue_style('google-font1', $bodyfonturl); 
		 }
     if ($headingfont != 'default' && $headingfont != ''){
      wp_enqueue_style('google-font2', $headingfonturl);
		 }
     if ($descriptionfont != 'default' && $descriptionfont != ''){
      wp_enqueue_style('google-font3', $descriptionfonturl);
		 }
     if ($headlinefont != 'default' && $headlinefont != ''){
      wp_enqueue_style('google-font4', $headlinefonturl); 
		 }
     if ($postentryfont != 'default' && $postentryfont != ''){
      wp_enqueue_style('google-font5', $postentryfonturl); 
		 }
     if ($sidebarfont != 'default' && $sidebarfont != ''){
      wp_enqueue_style('google-font6', $sidebarfonturl);
		 }
     if ($mottofont != 'default' && $mottofont != ''){
      wp_enqueue_style('google-font7', $mottofonturl);
		 }
     if ($menufont != 'default' && $menufont != ''){
      wp_enqueue_style('google-font8', $menufonturl);
		 }
}
add_action( 'wp_enqueue_scripts', 'timeturner_fonts_include' );
}

// additional js and css
function timeturner_css_include () {
	if (get_option('timeturner_css') == 'Green (default)' ){
			wp_enqueue_style('timeturner-style', get_stylesheet_uri());
		}

		if (get_option('timeturner_css') == 'Blue' ){
			wp_enqueue_style('style-blue', get_template_directory_uri().'/css/blue.css');
		}

		if (get_option('timeturner_css') == 'Gray' ){
			wp_enqueue_style('style-gray', get_template_directory_uri().'/css/gray.css');
		}

}
add_action( 'wp_enqueue_scripts', 'timeturner_css_include' );

// Display sidebar
function timeturner_display_sidebar() {
    $display_sidebar = get_option('timeturner_display_sidebar'); 
		if ($display_sidebar == 'Hide') { ?>
		<?php _e('#wrapper #wrapper-content #sidebar { display: none; } #wrapper #wrapper-content #content, #wrapper #wrapper-content .post-entry { width: 100%; }', 'timeturner'); ?>
<?php } 
}

// Display site description on sub-pages
function timeturner_display_site_description() {
    $display_site_description = get_option('timeturner_display_site_description'); 
		if ($display_site_description == 'Display') { ?>
		<?php _e('#header .description-wrapper { display: block; }', 'timeturner'); ?>
<?php } 
}

// Display site description on homepage
function timeturner_display_site_description_homepage() {
    $display_site_description_homepage = get_option('timeturner_display_site_description_homepage'); 
		if ($display_site_description_homepage == 'Hide') { ?>
		<?php _e('#wrapper #wrapper-header #header .description-wrapper { display: none; }', 'timeturner'); ?>
<?php } 
}

// Display sidebar in Blog Section on homepage
function timeturner_display_blog_sidebar() {
    $display_blog_sidebar = get_option('timeturner_display_blog_sidebar'); 
		if ($display_blog_sidebar == 'Hide') { ?>
		<?php _e('#wrapper #wrapper-blog #sidebar { display: none; } #wrapper #wrapper-blog #content, #wrapper #wrapper-blog .post-entry { width: 100%; }', 'timeturner'); ?>
<?php } 
}

// Menu Item offset
function timeturner_get_menu_item_offset() {
    $select_menu_item = get_option('timeturner_select_menu_item'); 
    $item_offset = get_option('timeturner_item_offset');
		if ($select_menu_item != '') { ?>
		<?php _e('#wrapper #wrapper-menu #menu .menu-item-', 'timeturner'); ?><?php echo $select_menu_item ?><?php _e(' { margin-left: ', 'timeturner'); ?><?php echo $item_offset ?><?php _e('px; }', 'timeturner'); ?>
<?php } 
}

// Body font
function timeturner_get_body_font() {
    $bodyfont = get_option('timeturner_body_google_fonts');
		if ($bodyfont != 'default' && $bodyfont != '') { ?>
		<?php _e('html body { font-family: "', 'timeturner'); ?><?php echo $bodyfont ?><?php _e('", Arial, Helvetica, sans-serif; }', 'timeturner'); ?>
<?php } 
}

// Site title font
function timeturner_get_headings_google_fonts() {
    $headingfont = get_option('timeturner_headings_google_fonts'); 
		if ($headingfont != 'default' && $headingfont != '') { ?>
		<?php _e('#wrapper #wrapper-header #header .site-title { font-family: "', 'timeturner'); ?><?php echo $headingfont ?><?php _e('", "Times New Roman", serif;}', 'timeturner'); ?>
<?php } 
}

// Site description font
function timeturner_get_description_font() {
    $descriptionfont = get_option('timeturner_description_google_fonts');
		if ($descriptionfont != 'default' && $descriptionfont != '') { ?>
		<?php _e('#wrapper #wrapper-header #header .site-description {font-family: "', 'timeturner'); ?><?php echo $descriptionfont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Homepage Motto font
function timeturner_get_motto_font() {
    $mottofont = get_option('timeturner_motto_google_fonts'); 
		if ($mottofont != 'default' && $mottofont != '') { ?>
		<?php _e('#wrapper #wrapper-header #header .header-motto {font-family: "', 'timeturner'); ?><?php echo $mottofont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Page/post headlines font
function timeturner_get_headlines_font() {
    $headlinefont = get_option('timeturner_headline_google_fonts'); 
		if ($headlinefont != 'default' && $headlinefont != '') { ?>
		<?php _e('#wrapper h1, #wrapper h2, #wrapper h3, #wrapper h4, #wrapper h5, #wrapper h6 { font-family: "', 'timeturner'); ?><?php echo $headlinefont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Post entry font
function timeturner_get_postentry_font() {
    $postentryfont = get_option('timeturner_postentry_google_fonts'); 
		if ($postentryfont != 'default' && $postentryfont != '') { ?>
		<?php _e('#wrapper #content .post-entry .post-entry-headline { font-family: "', 'timeturner'); ?><?php echo $postentryfont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Sidebar widget headlines font
function timeturner_get_sidebar_widget_font() {
    $sidebarfont = get_option('timeturner_sidebar_google_fonts');
		if ($sidebarfont != 'default' && $sidebarfont != '') { ?>
		<?php _e('#wrapper #sidebar .sidebar-widget .sidebar-headline { font-family: "', 'timeturner'); ?><?php echo $sidebarfont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Footer widget headlines font
function timeturner_get_footer_widget_font() {
    $sidebarfont = get_option('timeturner_sidebar_google_fonts');
		if ($sidebarfont != 'default' && $sidebarfont != '') { ?>
		<?php _e('#wrapper #wrapper-footer #footer .footer-widget .footer-headline { font-family: "', 'timeturner'); ?><?php echo $sidebarfont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Header menu font
function timeturner_get_menu_font() {
    $menufont = get_option('timeturner_menu_google_fonts'); 
		if ($menufont != 'default' && $menufont != '') { ?>
		<?php _e('#wrapper-menu #menu { font-family: "', 'timeturner'); ?><?php echo $menufont ?><?php _e('", "Times New Roman", serif; }', 'timeturner'); ?>
<?php } 
}

// Hide Post Meta paragraph if all values are disabled.
function timeturner_hide_post_meta() {
    $post_meta_date = get_option('timeturner_display_date_post');
    $post_meta_author = get_option('timeturner_display_author_post');
    $post_meta_category = get_option('timeturner_display_categories_post'); 
		if ($post_meta_date == 'Hide' && $post_meta_author == 'Hide' && $post_meta_category == 'Hide') { ?>
		<?php _e('#wrapper #content .post-meta { display: none; }', 'timeturner'); ?>
<?php } 
}

// User defined CSS.
function timeturner_get_own_css() {
    $own_css = get_option('timeturner_own_css'); 
		if ($own_css != '') { ?>
		<?php echo $own_css ?>
<?php } 
}

// Display custom CSS.
function timeturner_custom_styles() { ?>
<?php echo ("<style type='text/css'>"); ?>
<?php timeturner_get_own_css(); ?>
<?php timeturner_hide_post_meta(); ?>
<?php timeturner_display_sidebar(); ?>
<?php timeturner_display_site_description(); ?>
<?php timeturner_display_site_description_homepage(); ?>
<?php timeturner_display_blog_sidebar(); ?>
<?php timeturner_get_menu_item_offset(); ?>
<?php timeturner_get_body_font(); ?>
<?php timeturner_get_headings_google_fonts(); ?>
<?php timeturner_get_description_font(); ?>
<?php timeturner_get_motto_font(); ?>
<?php timeturner_get_headlines_font(); ?>
<?php timeturner_get_postentry_font(); ?>
<?php timeturner_get_sidebar_widget_font(); ?>
<?php timeturner_get_footer_widget_font(); ?>
<?php timeturner_get_menu_font(); ?>
<?php echo ("</style>"); ?>
<?php
} 
add_action('wp_enqueue_scripts', 'timeturner_custom_styles');	?>