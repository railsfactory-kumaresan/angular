<?php
/**
 * Framework setup.
 * @package TimeTurner
 * @since TimeTurner 1.0.0
*/

function timeturner_get_categories($parent) {
	global $wpdb, $table_prefix;
	$tb1 = "$table_prefix"."terms";
	$tb2 = "$table_prefix"."term_taxonomy";
	if ($parent == '0')	{
		$qqq = "AND $tb2".".parent = 0";
	} else	{
		$qqq = "";
	}
	
	$q = "SELECT $tb1.term_id,$tb1.name,$tb1.slug FROM $tb1,$tb2 WHERE $tb1.term_id = $tb2.term_id AND $tb2.taxonomy = 'category' $qqq ORDER BY $tb1.name ASC";
	$q = $wpdb->get_results($q);
	
	foreach ($q as $cat) {
		$categories[$cat->term_id] = $cat->name;
	} 
	return($categories);
}
		$categories = timeturner_get_categories(0);
		$categoriesParents = timeturner_get_categories(0);
		
	if (count($categories) > 0) {
	foreach ( $categories as $key => $value ) {
			$catids[] = $key;
			$catnames[] = $value;
	}
	}
	if (count($categoriesParents) > 0){
	foreach ( $categoriesParents as $key => $value ) {

		$catidsp[] = $key;
			$catnamesp[] = $value;
		}
}

function timeturner_bar_menu() {
	global $wp_admin_bar;
	if ( !is_super_admin() || !is_admin_bar_showing() )
		return;
		$admin_dir = get_admin_url();
		
	$wp_admin_bar->add_menu( array(
	'id' => 'custom_menu',
	'title' => __( 'Nastavení šablony', 'timeturner' ),
	'href' => $admin_dir .'admin.php?page=fw-options.php',
	'meta' => array('title' => 'TimeTurner nastavení', 'class' => 'timeturnerpanel') ) );
}
add_action('admin_bar_menu', 'timeturner_bar_menu', '1000');
?>