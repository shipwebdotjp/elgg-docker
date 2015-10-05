<?php 
/**
 * Docker CLI Elgg installer script 
 */
$autoload_path = '/var/www/html/vendor/autoload.php';
$autoload_available = include_once($autoload_path);
if (!$autoload_available) {
	die("Couldn't include '$autoload_path'. Did you run `composer install`?");
}

$installer = new ElggInstaller();

$params = array(
	// database parameters
	'dbuser' => getenv('ELGG_DB_USER'),
	'dbpassword' => getenv('ELGG_DB_PASS'),
	'dbname' => getenv('ELGG_DB_NAME'),
	'dbhost' => getenv('ELGG_DB_HOST'),
	'dbprefix' => getenv('ELGG_DB_PREFIX'),
	// site settings
	'sitename' => getenv('ELGG_SITE_NAME'),
	'siteemail' => getenv('ELGG_SITE_EMAIL'),
	'wwwroot' => getenv('ELGG_WWW_ROOT'),
	'dataroot' => getenv('ELGG_DATA_ROOT'),
	// admin account
	'displayname' => getenv('ELGG_DISPLAY_NAME'),
	'email' => getenv('ELGG_EMAIL'),
	'username' => getenv('ELGG_USERNAME'),
	'password' => getenv('ELGG_PASSWORD'),
	'path' => getenv('ELGG_PATH')
);



$installer->batchInstall($params, false);

exit(0);