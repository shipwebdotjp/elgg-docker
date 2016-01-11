<?php 
/**
 * Docker CLI Elgg installer script 
 */
require_once getenv('ELGG_PATH')."vendor/autoload.php";
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

if (strlen($params['password']) < 6) {
    echo "Elgg Admin password ({$params['password']}) must be at least 6 characters long.\n";
    exit(1);
}

$installer->batchInstall($params, true);

echo "Installation is complete.\n";
echo "Open in your browser: {$params['wwwroot']}\n";
echo "Elgg access credentials:\n";
echo "Elgg admin username: {$params['username']}\n";
echo "Elgg admin pass: {$params['password']}\n";

exit(0);