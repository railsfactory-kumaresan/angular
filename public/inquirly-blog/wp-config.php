<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'inquirly_blog');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'root');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '|OMQ&_{MPp$+<DSqzh/)il1%@Mta!XD*qTe(sI?LmQHP=W9r~;!AV;pSsFJl`CCH');
define('SECURE_AUTH_KEY',  '+*+CVjI?5JD&gdC#yv$Q|I1iGJ{]ze:^~X3JN*,yg4H?8mi>m}f]3qA35o@GJx8+');
define('LOGGED_IN_KEY',    'nK<;pL9]`XQj^2|WZ%!O^/.lH7-0p<a(iOx|>Hq!PKZS9IoT9=:G(!(awrXsT9L5');
define('NONCE_KEY',        '9%28VJXt`0P*+Q*O#g&6]>hyu(KE!8#^7Cev@|NQl{/[|i_t-7{|@v%>Bz>|u7rO');
define('AUTH_SALT',        '+AX?f&j1D/Fz$L(H-(~v^vJIlE}=SZQAs#*W`um15~R78r;a0EEcI34|v>eC-iae');
define('SECURE_AUTH_SALT', 'm}Rs-$sGql5%HCC8>{lZKg^!T}3S54eBO1pTx/m9FdrIL(}}vKvt5w|B{3~g)SSH');
define('LOGGED_IN_SALT',   'j!i5qh0]EAUt8L8_+w:6AVL*u h+TtOpFFZc;Lr(7y-q|bLE~KbA>+~C3F><~XgS');
define('NONCE_SALT',       'l.Hl[Tqg*2V#TDuFhzi4.0-U7A6(vj3<&1h2aY`Z73EoKx2~DI&+ppkL@bzG5]5}');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
