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
use Tygh\Mailer;

if ( !defined('BOOTSTRAP') ) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	if ($mode == 'add_extended') {

		if(1 || !isset($_REQUEST['post_data']['rating_value'])){
			$_REQUEST['post_data']['attributes'] = isset($_REQUEST['post_data']['attributes']) ? $_REQUEST['post_data']['attributes'] : array();
			$attributes = $_REQUEST['post_data']['attributes'];
			if(!empty($attributes)){
				$rate_value = 0;
				foreach($attributes as $value){
					$rate_value += $value;
				}
				$rate_value = floor($rate_value/count($attributes));
				$_REQUEST['post_data']['rating_value'] = $rate_value;
			}
		
			$discussion_settings = Registry::get('addons.discussion');
			$discussion_object_types = fn_get_discussion_objects();

			$suffix = '';
			$suffix = '&selected_section=discussion';
			if (AREA == 'C') {
				if (fn_image_verification('use_for_discussion', $_REQUEST) == false) {
					fn_save_post_data('post_data');

					return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['redirect_url'] . $suffix);
				}
			}

			$post_data = $_REQUEST['post_data'];

			if (!empty($post_data['thread_id'])) {
				$object = fn_extended_discussion_get_object_by_thread($post_data['thread_id']);
				if (empty($object)) {
					fn_set_notification('E', __('error'), __('cant_find_thread'));

					return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['redirect_url'] . $suffix);
				}
				$object_name = $discussion_object_types[$object['object_type']];
				$object_data = fn_get_discussion_object_data($object['object_id'], $object['object_type']);
				$ip = fn_get_ip();
				$post_data['ip_address'] = $ip['host'];
				$post_data['status'] = 'A';

				// Check if post is permitted from this IP address
				if (AREA != 'A' && !empty($discussion_settings[$object_name . '_post_ip_check']) && $discussion_settings[$object_name . '_post_ip_check'] == 'Y') {
					$is_exists = db_get_field("SELECT COUNT(*) FROM ?:discussion_posts WHERE thread_id = ?i AND ip_address = ?s", $post_data['thread_id'], $ip['host']);
					if (!empty($is_exists)) {
						fn_set_notification('E', __('error'), __('error_already_posted'));

						return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['redirect_url'] . $suffix);
					}
				}

				// Check if post needs to be approved
				if (AREA != 'A' && !empty($discussion_settings[$object_name . '_post_approval'])) {
					if ($discussion_settings[$object_name . '_post_approval'] == 'any' || ($discussion_settings[$object_name . '_post_approval'] == 'anonymous' && empty($auth['user_id']))) {
						fn_set_notification('W', __('text_thank_you_for_post'), __('text_post_pended'));
						$post_data['status'] = 'D';
					}
				}

				$post_data['timestamp'] = TIME;
				$post_data['user_id'] = $auth['user_id'];
				$post_data['post_id'] = db_query("INSERT INTO ?:discussion_posts ?e", $post_data);

				db_query("REPLACE INTO ?:discussion_messages ?e", $post_data);
				db_query("REPLACE INTO ?:discussion_rating ?e", $post_data);
			
				foreach($post_data['attributes'] as $attr_id => $rate){
						$_data['rating'] = $rate;
						$_data['attr_id'] = $attr_id;
						$_data['post_id'] = $post_data['post_id'];
						$_data = fn_check_table_fields($_data, 'review_rating');
						db_query("REPLACE INTO ?:review_rating ?e", $_data);
				}
				
				// For orders - set notification to admin and vendors or customer
				if ($object['object_type'] == 'O') {

					$order_info = db_get_row("SELECT email, company_id, lang_code FROM ?:orders WHERE order_id = ?i", $object['object_id']);

					if (AREA == 'C') {
						//Send to admin
						Mailer::sendMail(array(
							'to' => 'default_company_orders_department',
							'from' => array(
								'email' => $order_info['email'],
								'name' => $post_data['name'],
							),
							'data' => array(
								'url' => fn_url("orders.details?order_id=$object[object_id]", 'A', 'http', null, true),
								'object_data' => $object_data,
								'post_data' => $post_data,
								'object_name' => $object_name,
								'subject' => __('discussion_title_' . $discussion_object_types[$object['object_type']], '', Registry::get('settings.Appearance.backend_default_language')) . ' - ' . __($discussion_object_types[$object['object_type']], '', Registry::get('settings.Appearance.backend_default_language')),
							),
							'tpl' => 'addons/discussion/notification.tpl',
							'company_id' => $order_info['company_id'],
						), 'A', Registry::get('settings.Appearance.backend_default_language'));

						//Send to vendor
						if (!empty($order_info['company_id']) && !empty($discussion_settings[$object_name . '_notify_vendor']) && $discussion_settings[$object_name . '_notify_vendor'] == 'Y') {
							Mailer::sendMail(array(
								'to' => 'company_orders_department',
								'from' => array(
									'email' => $order_info['email'],
									'name' => $post_data['name'],
								),
								'data' => array(
									'url' => fn_url("orders.details?order_id=$object[object_id]", 'V', 'http', null, true),
									'object_data' => $object_data,
									'post_data' => $post_data,
									'object_name' => $object_name,
									'subject' => __('discussion_title_' . $discussion_object_types[$object['object_type']], '', fn_get_company_language($order_info['company_id'])) . ' - ' . __($discussion_object_types[$object['object_type']], '', fn_get_company_language($order_info['company_id'])),
								),
								'tpl' => 'addons/discussion/notification.tpl',
								'company_id' => $order_info['company_id'],
							), 'A', fn_get_company_language($order_info['company_id']));
						}

					} elseif (AREA == 'A') {
						Mailer::sendMail(array(
							'to' => $order_info['email'],
							'from' => 'company_orders_department',
							'data' => array(
								'url' => fn_url("orders.details?order_id=$object[object_id]", 'C', 'http', null, true),
								'object_data' => $object_data,
								'post_data' => $post_data,
								'object_name' => $object_name,
								'subject' => __('discussion_title_' . $discussion_object_types[$object['object_type']], '', $order_info['lang_code']) . ' - ' . __($discussion_object_types[$object['object_type']], '', $order_info['lang_code']),
							),
							'tpl' => 'addons/discussion/notification.tpl',
							'company_id' => $order_info['company_id'],
						), 'C', $order_info['lang_code']);
					}
				} elseif (!empty($discussion_settings[$object_name . '_notification_email']) || (!empty($discussion_settings[$object_name . '_notify_vendor']) && $discussion_settings[$object_name . '_notify_vendor'] == 'Y')) {

					$company_id = 0;
					if (fn_allowed_for('MULTIVENDOR')) {
						if ($object_name == 'product') {
							$company_id = db_get_field("SELECT company_id FROM ?:products WHERE product_id = ?i", $object['object_id']);
						} elseif ($object_name == 'page') {
							$company_id = db_get_field("SELECT company_id FROM ?:pages WHERE page_id = ?i", $object['object_id']);
						} elseif ($object_name == 'company') {
							$company_id = $object['object_id'];
						}
					}

					$url = "discussion_manager.manage?object_type=$object[object_type]&post_id=$post_data[post_id]";

					if (!empty($discussion_settings[$object_name . '_notification_email'])) {
						Mailer::sendMail(array(
							'to' => $discussion_settings[$object_name . '_notification_email'],
							'from' => 'company_site_administrator',
							'data' => array(
								'url' => fn_url($url, 'A', 'http', null, true),
								'object_data' => $object_data,
								'post_data' => $post_data,
								'object_name' => $object_name,
								'subject' => __('discussion_title_' . $discussion_object_types[$object['object_type']], '', Registry::get('settings.Appearance.backend_default_language')) . ' - ' . __($discussion_object_types[$object['object_type']], '', Registry::get('settings.Appearance.backend_default_language')),
							),
							'tpl' => 'addons/discussion/notification.tpl',
							'company_id' => $company_id,
						), 'A', Registry::get('settings.Appearance.backend_default_language'));
					}

					//Send to vendor
					if (!empty($company_id) && !empty($discussion_settings[$object_name . '_notify_vendor']) && $discussion_settings[$object_name . '_notify_vendor'] == 'Y') {

						$url = ($object_name == 'company' ? 'companie' : $object_name) . "s.update?$object_name" . "_id=$object[object_id]&selected_section=discussion";
						Mailer::sendMail(array(
							'to' => 'company_site_administrator',
							'from' => 'default_company_site_administrator',
							'data' => array(
								'url' => fn_url($url, 'V', 'http', null, true),
								'object_data' => $object_data,
								'post_data' => $post_data,
								'object_name' => $object_name,
								'subject' => __('discussion_title_' . $discussion_object_types[$object['object_type']], '', fn_get_company_language($company_id)) . ' - ' . __($discussion_object_types[$object['object_type']], '', fn_get_company_language($company_id)),
							),
							'tpl' => 'addons/discussion/notification.tpl',
							'company_id' => $company_id,
						), 'A', fn_get_company_language($company_id));
					}
				}

			}
			
			$redirect_url = isset($redirect_url) ? $redirect_url : $_REQUEST['redirect_url'];
			
			return array(CONTROLLER_STATUS_OK, $redirect_url);
			
		}

	}
}

function fn_extended_discussion_get_object_by_thread($thread_id)
{
	static $cache = array();

	if (empty($cache[$thread_id])) {
		$cache[$thread_id] = db_get_row("SELECT object_type, object_id, type FROM ?:discussion WHERE thread_id = ?i", $thread_id);
	}

	return $cache[$thread_id];
}
?>