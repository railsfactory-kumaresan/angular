<?php
/**
 * TimeTurner functions and definitions.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/

/**
 * TimeTurner theme variables.
 *  
*/    
$timeturner_lang = get_bloginfo( 'language' );		//Blog Language
$timeturner_themename = "TimeTurner";									//Theme Name
$timeturner_themever = "1.0.0";										//Theme version
$timeturner_shortname = "timeturner";											//Shortname 
$timeturner_manualurl = get_template_directory_uri() . '/docs/documentation.html';	//Manual Url
// Set path to TimeTurner Framework and theme specific functions
if ( $timeturner_lang=="cs-CZ" )
$timeturner_be_path = get_template_directory() . '/functions/be/cz/';									//BackEnd Path
else $timeturner_be_path = get_template_directory() . '/functions/be/';									//BackEnd Path
$timeturner_fe_path = get_template_directory() . '/functions/fe/';									//FrontEnd Path 
$timeturner_be_pathimages = get_template_directory_uri() . '/functions/be/images';		//BackEnd Path
$timeturner_fe_pathimages = get_template_directory_uri() . '';							//FrontEnd Path
//Include Framework [BE] 
require_once ($timeturner_be_path . 'fw-setup.php');					// Init 
require_once ($timeturner_be_path . 'fw-options.php');					// Framework Init  
// Include Theme specific functionality [FE] 
require_once ($timeturner_fe_path . 'headerdata.php');					// Include css and js
require_once ($timeturner_fe_path . 'library.php');					// Include library, functions

/**
 * TimeTurner theme basic setup.
 *  
*/
function timeturner_setup() {
	// Makes TimeTurner available for translation.
	load_theme_textdomain( 'timeturner', get_template_directory() . '/languages' );
	// Adds RSS feed links to <head> for posts and comments.  
	add_theme_support( 'automatic-feed-links' );
	// This theme supports custom background color.
	$defaults = array(
	'default-color'          => '', 
	'wp-head-callback'       => '_custom_background_cb',
	'admin-head-callback'    => '',
	'admin-preview-callback' => '' );  
  add_theme_support( 'custom-background', $defaults );
	// This theme uses a custom image size for featured images, displayed on "standard" posts.
	add_theme_support( 'post-thumbnails' );
	set_post_thumbnail_size( 680, 9999 );
  add_image_size( 'portfolio-thumb', 290, 290, true );
}
add_action( 'after_setup_theme', 'timeturner_setup' );

/**
 * Enqueues scripts and styles for front-end.
 *
*/
function timeturner_scripts_styles() {
	global $wp_styles;
	// Adds JavaScript
	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) )
		wp_enqueue_script( 'comment-reply' );
    wp_enqueue_script( 'placeholders', get_template_directory_uri() . '/js/placeholders.js', array(), '2.1.0', true );
    wp_enqueue_script( 'selectnav', get_template_directory_uri() . '/js/selectnav.js', array(), '0.1', true );
    wp_enqueue_script( 'responzive', get_template_directory_uri() . '/js/responzive.js', array(), '1.0', true );
	// Loads the main stylesheet.
	  wp_enqueue_style( 'timeturner-style', get_stylesheet_uri() ); 
    wp_enqueue_style( 'google-font-default', 'http://fonts.googleapis.com/css?family=Amarante' );
  // Loads additional stylesheet for IE8 and older versions.
    wp_enqueue_style( 'timeturner-style-ie', get_template_directory_uri() . '/css/style-ie.css' );
    // Apply IE conditionals
    $GLOBALS['wp_styles']->add_data( 'timeturner-style-ie', 'conditional', 'lte IE 8' );
}
add_action( 'wp_enqueue_scripts', 'timeturner_scripts_styles' ); 

/**
 * Sets up the content width value based on the theme's design and stylesheet.
 *  
*/
if ( ! isset( $content_width ) )
	$content_width = 680;
  
/**
 * Creates a nicely formatted and more specific title element text.
 *  
*/
function timeturner_wp_title( $title, $sep ) {
	if ( is_feed() )
		return $title;
	$title .= get_bloginfo( 'name' );
	$site_description = get_bloginfo( 'description', 'display' );
	if ( $site_description && ( is_home() || is_front_page() ) )
		$title = "$title $sep $site_description";
	return $title;
}
add_filter( 'wp_title', 'timeturner_wp_title', 10, 2 );

/**
 * Register our menus.
 *
 */
function timeturner_register_my_menus() {
  register_nav_menus(
    array(
      'header-menu' => __( 'Header Menu', 'timeturner' ),
      'sidebar-menu' => __( 'Sidebar Menu', 'timeturner' )
    )
  );
}
add_action( 'after_setup_theme', 'timeturner_register_my_menus' );

/**
 * Register our sidebars and widgetized areas.
 *
*/
function timeturner_widgets_init() {
	register_sidebar( array(
		'name' => __( 'Index-blog Sidebar', 'timeturner' ),
		'id' => 'sidebar-1',
		'description' => __( 'Right sidebar which appears on index page in Blog section.', 'timeturner' ),
		'before_widget' => '<div class="sidebar-widget">',
		'after_widget' => '</div>',
		'before_title' => '<p class="sidebar-headline">',
		'after_title' => '</p>',
	) );
  register_sidebar( array(
		'name' => __( 'Main Sidebar', 'timeturner' ),
		'id' => 'sidebar-2',
		'description' => __( 'Right sidebar which appears on posts and pages.', 'timeturner' ),
		'before_widget' => '<div class="sidebar-widget">',
		'after_widget' => '</div>',
		'before_title' => '<p class="sidebar-headline">',
		'after_title' => '</p>',
	) );
  register_sidebar( array(
		'name' => __( 'Footer left widget area', 'timeturner' ),
		'id' => 'sidebar-3',
		'description' => __( 'Left column with widgets in footer.', 'timeturner' ),
		'before_widget' => '<div class="footer-widget">',
		'after_widget' => '</div>',
		'before_title' => '<p class="footer-headline">',
		'after_title' => '</p>',
	) );
  register_sidebar( array(
		'name' => __( 'Footer middle widget area', 'timeturner' ),
		'id' => 'sidebar-4',
		'description' => __( 'Middle column with widgets in footer.', 'timeturner' ),
		'before_widget' => '<div class="footer-widget">',
		'after_widget' => '</div>',
		'before_title' => '<p class="footer-headline">',
		'after_title' => '</p>',
	) );
  register_sidebar( array(
		'name' => __( 'Footer right widget area', 'timeturner' ),
		'id' => 'sidebar-5',
		'description' => __( 'Right column with widgets in footer.', 'timeturner' ),
		'before_widget' => '<div class="footer-widget">',
		'after_widget' => '</div>',
		'before_title' => '<p class="footer-headline">',
		'after_title' => '</p>',
	) );
  register_sidebar( array(
		'name' => __( 'Footer notices', 'timeturner' ),
		'id' => 'sidebar-6',
		'description' => __( 'The line for copyright and other notices below the footer widget areas. Insert here one Text widget. The "Title" field at this widget should stay empty.', 'timeturner' ),
		'before_widget' => '<div class="footer-signature"><div class="footer-signature-content">',
		'after_widget' => '</div></div>',
		'before_title' => '',
		'after_title' => '',
	) );
  register_sidebar( array(
		'name' => __( 'Homepage slideshow', 'timeturner' ),
		'id' => 'sidebar-7',
		'description' => __( 'The area for Cyclone Slider Widget which displays a slideshow on your homepage.', 'timeturner' ),
		'before_widget' => '<div id="slideshow-main-wrapper"><div class="slideshow-background">',
		'after_widget' => '<div class="slideshow-top-left-radius slideshow-radius"></div><div class="slideshow-top-right-radius slideshow-radius"></div><div class="slideshow-bottom-left-radius slideshow-radius"></div><div class="slideshow-bottom-right-radius slideshow-radius"></div></div></div>',
		'before_title' => '',
		'after_title' => '',
	) );
  register_sidebar( array(
		'name' => __( 'About Section boxes on homepage', 'timeturner' ),
		'id' => 'sidebar-8',
		'description' => __( 'Insert here as many Text widgets as you want for displaying boxes in About Section on your homepage.', 'timeturner' ),
		'before_widget' => '<div class="about-box"><div class="about-box-inner"><div class="about-box-content">',
		'after_widget' => '</div></div><div class="about-top-left-radius about-radius"></div><div class="about-top-right-radius about-radius"></div><div class="about-bottom-left-radius about-radius"></div><div class="about-bottom-right-radius about-radius"></div></div>',
		'before_title' => '<h3>',
		'after_title' => '</h3>',
	) );
}
add_action( 'widgets_init', 'timeturner_widgets_init' );

if ( ! function_exists( 'timeturner_content_nav' ) ) :
/**
 * Displays navigation to next/previous pages when applicable.
 *
*/
function timeturner_content_nav( $html_id ) {
	global $wp_query;
	$html_id = esc_attr( $html_id );
	if ( $wp_query->max_num_pages > 1 ) : ?>
		<div id="<?php echo $html_id; ?>" class="navigation" role="navigation">
			<h3 class="navigation-headline section-heading"><?php _e( 'Post navigation', 'timeturner' ); ?></h3>
			<p class="nav-previous"><?php next_posts_link( __( '<span class="meta-nav">&larr;</span> Older posts', 'timeturner' ) ); ?></p>
			<p class="nav-next"><?php previous_posts_link( __( 'Newer posts <span class="meta-nav">&rarr;</span>', 'timeturner' ) ); ?></p>
		</div>
	<?php endif;
}
endif;

/**
 * Displays navigation to next/previous posts on single posts pages.
 *
*/
function timeturner_prev_next($nav_id) { ?>
<div id="<?php echo $nav_id; ?>" class="navigation" role="navigation">
  <h3 class="navigation-headline section-heading"><?php _e( 'Post navigation', 'timeturner' ); ?></h3>
	<p class="nav-previous"><?php previous_post_link('%link', __( '&larr; Previous post' , 'timeturner' )); ?></p>
	<p class="nav-next"><?php next_post_link('%link', __( 'Next post &rarr;' , 'timeturner' )); ?></p>
</div>
<?php } 

if ( ! function_exists( 'timeturner_comment' ) ) :
/**
 * Template for comments and pingbacks.
 *
*/
function timeturner_comment( $comment, $args, $depth ) {
	$GLOBALS['comment'] = $comment;
	switch ( $comment->comment_type ) :
		case 'pingback' :
		case 'trackback' :
	?>
	<li <?php comment_class(); ?> id="comment-<?php comment_ID(); ?>">
		<p><?php _e( 'Pingback:', 'timeturner' ); ?> <?php comment_author_link(); ?> <?php edit_comment_link( __( '(Edit)', 'timeturner' ), '<span class="edit-link">', '</span>' ); ?></p>
	<?php
			break;
		default :
		global $post;
	?>
	<li <?php comment_class(); ?> id="li-comment-<?php comment_ID(); ?>">
		<div id="comment-<?php comment_ID(); ?>" class="comment">
			<div class="comment-meta comment-author vcard">
				<?php
					echo get_avatar( $comment, 44 );
					printf( '<span><b class="fn">%1$s</b> %2$s</span>',
						get_comment_author_link(),
						( $comment->user_id === $post->post_author ) ? '<span>' . __( '(Post author)', 'timeturner' ) . '</span>' : ''
					);
					printf( '<time datetime="%2$s">%3$s</time>',
						esc_url( get_comment_link( $comment->comment_ID ) ),
						get_comment_time( 'c' ),
						// translators: 1: date, 2: time
						sprintf( __( '%1$s at %2$s', 'timeturner' ), get_comment_date(''), get_comment_time() )
					);
				?>
			</div><!-- .comment-meta -->

			<?php if ( '0' == $comment->comment_approved ) : ?>
				<p class="comment-awaiting-moderation"><?php _e( 'Your comment is awaiting moderation.', 'timeturner' ); ?></p>
			<?php endif; ?>

			<div class="comment-content comment">
				<?php comment_text(); ?>
				<?php edit_comment_link( __( 'Edit', 'timeturner' ), '<p class="edit-link">', '</p>' ); ?>
			</div><!-- .comment-content -->

			<div class="reply">
				<?php comment_reply_link( array_merge( $args, array( 'reply_text' => __( 'Reply', 'timeturner' ), 'after' => ' <span>&darr;</span>', 'depth' => $depth, 'max_depth' => $args['max_depth'] ) ) ); ?>
			</div><!-- .reply -->
		</div><!-- #comment-## -->
	<?php
		break;
	endswitch;
}
endif;

/**
 * Custom Shortcodes.
 *
*/
function timeturner_button_shortcode($atts, $content = null) {
   extract(shortcode_atts(array('link' => '#'), $atts));
   return '<a class="custom-button" href="'.$link.'">' . do_shortcode($content) . '</a>';
}
add_shortcode( 'button', 'timeturner_button_shortcode' );
add_filter('widget_text', 'do_shortcode');

function timeturner_read_more_shortcode($atts, $content = null) {
   extract(shortcode_atts(array('link' => '#'), $atts));
   return '<a class="read-more-button" href="'.$link.'">' . do_shortcode($content) . '</a>';
}
add_shortcode( 'more-button', 'timeturner_read_more_shortcode' );

/**
 * Place the "Continue reading" link in the excerpt.
 *
*/
 function timeturner_new_excerpt_more($more) {
       global $post;
	return '... (<a href="'. get_permalink($post->ID) . '">'. _e( 'Read more', 'timeturner' ). '</a>)';
}
add_filter('excerpt_more', 'timeturner_new_excerpt_more');

/**
 * Function for rendering CSS3 features in IE.
 *
*/
add_filter( 'wp_head' , 'timeturner_pie' );
function timeturner_pie() { ?>
<!--[if IE]>
<style type="text/css" media="screen">
#wrapper-menu, #header-logo, .scroll-top, .scroll-top:hover, .portfolio-box, .portfolio-box:hover, .post-entry .attachment-post-thumbnail {
        behavior: url("<?php echo get_template_directory_uri() . '/css/pie/PIE.php'; ?>");
        zoom: 1;
}
</style>
<![endif]-->
<?php }

/**
 * Function for adding custom classes to the menu objects.
 *
*/
add_filter( 'wp_nav_menu_objects', 'timeturner_filter_menu_class', 10, 2 );
function timeturner_filter_menu_class( $objects, $args ) {
    if ( isset( $args->theme_location ) )
    if ( 'header-menu' !== $args->theme_location )
    return $objects;
    
    $ids        = array();
    $parent_ids = array();
    $top_ids    = array();
    foreach ( $objects as $i => $object ) {
        if ( 0 == $object->menu_item_parent ) {
            $top_ids[$i] = $object;
            continue;
        }
        if ( ! in_array( $object->menu_item_parent, $ids ) ) {
            $objects[$i]->classes[] = 'first-menu-item';
            $ids[]          = $object->menu_item_parent;
        }
        if ( in_array( 'first-menu-item', $object->classes ) )
            continue;
        $parent_ids[$i] = $object->menu_item_parent;
    }
    $sanitized_parent_ids = array_unique( array_reverse( $parent_ids, true ) );
    foreach ( $sanitized_parent_ids as $i => $id )
        $objects[$i]->classes[] = 'last-menu-item'; 
        
    $get_menu_item = array_keys( $top_ids );
    if (array_key_exists('1', $get_menu_item)) { $menu_item_2 = $get_menu_item[1]; };
    if (array_key_exists('2', $get_menu_item)) { $menu_item_3 = $get_menu_item[2]; };
    if (array_key_exists('3', $get_menu_item)) { $menu_item_4 = $get_menu_item[3]; };
    if (array_key_exists('4', $get_menu_item)) { $menu_item_5 = $get_menu_item[4]; };
    if (array_key_exists('5', $get_menu_item)) { $menu_item_6 = $get_menu_item[5]; };
    if (array_key_exists('6', $get_menu_item)) { $menu_item_7 = $get_menu_item[6]; };
    if (array_key_exists('7', $get_menu_item)) { $menu_item_8 = $get_menu_item[7]; };
    if (array_key_exists('8', $get_menu_item)) { $menu_item_9 = $get_menu_item[8]; };
    if (array_key_exists('9', $get_menu_item)) { $menu_item_10 = $get_menu_item[9]; };

    $objects[1]->classes[] = 'menu-item-1';   
    if (array_key_exists('1', $get_menu_item)) { $objects[$menu_item_2]->classes[] = 'menu-item-2'; };
    if (array_key_exists('2', $get_menu_item)) { $objects[$menu_item_3]->classes[] = 'menu-item-3'; };
    if (array_key_exists('3', $get_menu_item)) { $objects[$menu_item_4]->classes[] = 'menu-item-4'; };
    if (array_key_exists('4', $get_menu_item)) { $objects[$menu_item_5]->classes[] = 'menu-item-5'; };
    if (array_key_exists('5', $get_menu_item)) { $objects[$menu_item_6]->classes[] = 'menu-item-6'; };
    if (array_key_exists('6', $get_menu_item)) { $objects[$menu_item_7]->classes[] = 'menu-item-7'; };
    if (array_key_exists('7', $get_menu_item)) { $objects[$menu_item_8]->classes[] = 'menu-item-8'; };
    if (array_key_exists('8', $get_menu_item)) { $objects[$menu_item_9]->classes[] = 'menu-item-9'; };
    if (array_key_exists('9', $get_menu_item)) { $objects[$menu_item_10]->classes[] = 'menu-item-10'; };
    $last_top_menu_item = array_keys($top_ids);
    $objects[end($last_top_menu_item)]->classes[] = 'last-top-menu-item'; 
    return $objects;
 }

/**
 * Include the TGM_Plugin_Activation class.
 *  
*/
require_once get_template_directory() . '/class-tgm-plugin-activation.php'; 
add_action( 'tgmpa_register', 'timeturner_my_theme_register_required_plugins' );

function timeturner_my_theme_register_required_plugins() {

$plugins = array(
		array(
			'name'     => 'Cyclone Slider 2',
			'slug'     => 'cyclone-slider-2',
			'source'   => get_template_directory_uri() . '/plugins/cyclone-slider-2.zip',
			'required' => false,
		),
	);
 
 
$config = array(
		'domain'       => 'timeturner',
    'menu'         => 'install-my-theme-plugins',
		'strings'      	 => array(
		'page_title'             => __( 'Install Required Plugins', 'timeturner' ),
		'menu_title'             => __( 'Install Plugins', 'timeturner' ),
		'instructions_install'   => __( 'The %1$s plugin is required for this theme. Click on the big blue button below to install and activate %1$s.', 'timeturner' ),
		'instructions_activate'  => __( 'The %1$s is installed but currently inactive. Please go to the <a href="%2$s">plugin administration page</a> page to activate it.', 'timeturner' ),
		'button'                 => __( 'Install %s Now', 'timeturner' ),
		'installing'             => __( 'Installing Plugin: %s', 'timeturner' ),
		'oops'                   => __( 'Something went wrong with the plugin API.', 'timeturner' ), // */
		'notice_can_install'     => __( 'This theme requires the %1$s plugin. <a href="%2$s"><strong>Click here to begin the installation process</strong></a>. You may be asked for FTP credentials based on your server setup.', 'timeturner' ),
		'notice_cannot_install'  => __( 'Sorry, but you do not have the correct permissions to install the %s plugin. Contact the administrator of this site for help on getting the plugin installed.', 'timeturner' ),
		'notice_can_activate'    => __( 'This theme requires the %1$s plugin. That plugin is currently inactive, so please go to the <a href="%2$s">plugin administration page</a> to activate it.', 'timeturner' ),
		'notice_cannot_activate' => __( 'Sorry, but you do not have the correct permissions to activate the %s plugin. Contact the administrator of this site for help on getting the plugin activated.', 'timeturner' ),
		'return'                 => __( 'Return to Required Plugins Installer', 'timeturner' ),
),
); 
tgmpa( $plugins, $config ); 
}
?>