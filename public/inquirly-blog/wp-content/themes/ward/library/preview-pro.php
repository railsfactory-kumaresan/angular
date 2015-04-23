<?php
class Bavotasan_Preview_Pro {
	public function __construct() {
		add_action( 'admin_bar_menu', array( $this, 'admin_bar_menu' ), 1000 );
		add_action( 'admin_menu', array( $this, 'admin_menu' ) );
	}

	/**
	 * Add a 'Preview Pro' menu item to the admin bar
	 *
	 * This function is attached to the 'admin_bar_menu' action hook.
	 *
	 * @since 1.0.0
	 */
	public function admin_bar_menu( $wp_admin_bar ) {
	    if ( current_user_can( 'edit_theme_options' ) && is_admin_bar_showing() )
	    	$wp_admin_bar->add_node( array( 'parent' => 'bavotasan_toolbar', 'id' => 'preview_pro', 'title' => sprintf( __( 'Preview %s Pro', 'ward' ), BAVOTASAN_THEME_NAME ), 'href' => esc_url( admin_url( 'themes.php?page=bavotasan_preview_pro' ) ) ) );
	}

	/**
	 * Add a 'Preview Pro' menu item to the Appearance panel
	 *
	 * This function is attached to the 'admin_menu' action hook.
	 *
	 * @since 1.0.0
	 */
	public function admin_menu() {
		add_theme_page( sprintf( __( 'Preview %s Pro', 'ward' ), BAVOTASAN_THEME_NAME ), sprintf( __( 'Preview %s Pro', 'ward' ), BAVOTASAN_THEME_NAME ), 'edit_theme_options', 'bavotasan_preview_pro', array( $this, 'bavotasan_preview_pro' ) );
	}

	public function bavotasan_preview_pro() {
		$theme_url = 'https://themes.bavotasan.com/2013/ward-pro/';
		$youtube_url = 'http://youtu.be/r-ZemVT_0u8';
		?>
		<div class="wrap" id="custom-background">
			<div id="icon-themes" class="icon32"></div>
			<h2><?php echo get_admin_page_title(); ?></h2>
			<p><a href="<?php echo $youtube_url; ?>" target="_blank"><img src="<?php echo BAVOTASAN_THEME_URL; ?>/library/images/preview.jpg" alt="" /></a></p>

			<p><?php printf( __( '%s can help take your website to the next level. Here\'s a list of some of the advanced features.', 'ward' ), '<strong>' . BAVOTASAN_THEME_NAME . ' Pro</strong>' ); ?></p>
			<ul style="padding-left: 20px; list-style: disc; margin-bottom: 20px;">
				<li>Multiple Sidebar Layouts</li>
				<li>Full Width Posts/Pages</li>
				<li>Extended Widgetized Footer</li>
				<li>Twitter Bootstrap Shortcodes</li>
				<li>Font Selector with 20 Google Fonts</li>
				<li>Custom CSS Editor</li>
				<li>Theme Options Import/Export</li>
				<li>Font Awesome Icons</li>
				<li>JetPack Infinity Scroll Support</li>
				<li>Advanced Color Picker</li>
				<li>And a whole lot more...</li>
			</ul>
			<p><a href="<?php echo $theme_url; ?>" class="button button-large"><?php printf( __( 'Buy %s Now &rarr;', 'ward' ), '<strong>' . BAVOTASAN_THEME_NAME . ' Pro</strong>' ); ?></a></p>
		</div>
		<?php
	}
}
$bavotasan_preview_pro = new Bavotasan_Preview_Pro;