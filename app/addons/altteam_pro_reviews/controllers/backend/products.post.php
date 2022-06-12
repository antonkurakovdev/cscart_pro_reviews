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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	if ($mode == 'update') {
		if(!empty($_REQUEST['posts']) && is_array($_REQUEST['posts'])){
			
			foreach ($_REQUEST['posts'] as $p_id => $post){
				if(!empty($post['attributes'])){
					foreach($post['attributes'] as $attr_id => $rate){
						$_data['rating'] = $rate;
						$_data['attr_id'] = $attr_id;
						$_data['post_id'] = $p_id;
						$_data = fn_check_table_fields($_data, 'review_rating');
						db_query("REPLACE INTO ?:review_rating ?e", $_data);
					}
				}
			}
		}
	}
}

if ($mode == 'update') {
	$product_id = empty($_REQUEST['product_id']) ? 0 : intval($_REQUEST['product_id']);

    $review_attributes = fn_get_review_attributes($product_id);

    Registry::get('view')->assign('review_attributes', $review_attributes);

	Registry::set('navigation.tabs.review_attributes', array (
		'title' => __('review_attributes'),
		'js' => true
	));

}
?>