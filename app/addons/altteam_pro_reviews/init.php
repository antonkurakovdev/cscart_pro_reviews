<?php

/*****************************************************************************
 * This is a commercial software, only users who have purchased a  valid
 * license and accepts the terms of the License Agreement can install and use  
 * this program.
 *----------------------------------------------------------------------------
 * @copyright  LCC Alt-team: https://www.alt-team.com
 * @module     "Alt-team: Extends the existing version of discussions"
 * @license    https://www.alt-team.com/addons-license-agreement.html
 ****************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

define('DIR_DOWNLOADS_SHEET', Registry::get('config.dir.root') . '/var/downloads_sheet/');

fn_register_hooks(
	'redirect',
	'update_product_post',
    'get_discussion'
);

?>