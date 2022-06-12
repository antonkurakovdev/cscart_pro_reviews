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

if ( !defined('BOOTSTRAP') ) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	if($mode == 'update'){
		if (!empty($_REQUEST['review_attributes'])){
			fn_trusted_vars('review_attributes');
			$object_id = $_REQUEST['product_id'] ? $_REQUEST['product_id'] : 0;
			
			fn_update_review_attributes($_REQUEST['review_attributes'], $object_id);
		}
		$suffix = '.manage';
		if (!empty($_REQUEST['redirect_url'])){
			return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['redirect_url']);
		}
	}
	// Apply global attributes to the selected products
if ($mode == 'apply') {
		
		if (!empty($_REQUEST['apply_attributes']['attributes'])) {
			$_data = $_REQUEST['apply_attributes'];

			foreach ($_data['attributes'] as $key => $attr_id) {
				$object_ids = empty($_data['object_ids']) ? array() : explode(',', $_data['object_ids']);
//[Ruslan]			
				if (empty($object_ids)) {
					$object_ids = db_get_fields('SELECT product_id FROM ?:products');
				}

				foreach ($object_ids as $k) {
					db_query("DELETE FROM ?:review_attributes_links WHERE object_id =?i AND attr_id NOT IN (?n)", $k, $_data['attributes']);
				}
			
				foreach ($object_ids as $k) {
					db_query("REPLACE INTO ?:review_attributes_links (attr_id, object_id, object_type) VALUES (?i, ?i, ?s)", $attr_id, $k, $_data['object_type']);
				}
			}
			if (!empty($object_ids)) {
				fn_set_notification('N', __('notice'), __('attributes_have_been_applied_to_products'));
			}
		} elseif (empty($_REQUEST['apply_attributes']['object_ids']) || !isset($_REQUEST['apply_attributes']['object_ids'])) {
				db_query("DELETE FROM ?:review_attributes_links");
		} elseif (!empty($_REQUEST['apply_attributes']['object_ids']) && isset($_REQUEST['apply_attributes']['object_ids'])) {
				
				$object_ids = empty($_REQUEST['apply_attributes']['object_ids']) ? array() : explode(',', $_REQUEST['apply_attributes']['object_ids']);
				foreach ($object_ids as $k => $v) {
					db_query("DELETE FROM ?:review_attributes_links WHERE object_id =?i", $v);
				}
				
		}
//[/Ruslan]	
		$suffix = ".apply";
	}
	return array(CONTROLLER_STATUS_REDIRECT, 'review_attributes'.$suffix);
}

if ($mode == 'manage') {
// 	if (!defined('REVIEW_ATTRIBUTES_VERSION') || REVIEW_ATTRIBUTES_VERSION != Registry::get('settings.review_attributes_version')) {
// 		$menu['upgrade'] = array (
// 			'title' => __('upgrade'),
// 			'href' => INDEX_SCRIPT . '?dispatch=review_attributes.upgrade',
// 		);
// 		Registry::set('navigation.dynamic.sections', $menu);
// 		Registry::set('navigation.dynamic.active_section', $mode);
// 	}

	$review_attributes = fn_get_review_attributes();

	Registry::get('view')->assign('review_attributes', $review_attributes);

} elseif ($mode == 'apply'){
//[Ruslan]
	$review_attributes = fn_get_review_attributes_work();
	
// 	$products = db_get_fields('SELECT DISTINCT object_id FROM ?:review_attributes_links');
// 	
// 	foreach ($products as $k => $prod_id) {
// 		$prod_list[$k]['product_id'] = $prod_id;
// 		$prod_list[$k]['attr_ids'] = db_get_fields('SELECT attr_id FROM ?:review_attributes_links WHERE object_id = ?i', $prod_id);
// 	}
	Registry::get('view')->assign('review_attributes', $review_attributes);
//[/Ruslan]

} elseif ($mode == 'upgrade') {
	$addon = 'altteam_review_attributes';
	$rewrite_opts = array();
	$xml = simplexml_load_file(Registry::get('config.dir.addons') . $addon . '/addon.xml');
	if (isset($xml->opt_settings)) {
		$options = db_get_field("SELECT options FROM ?:addons WHERE addon = ?s", $addon);
		$options = fn_parse_addon_options($options);
		$sections_node = isset($xml->opt_settings->section) ? $xml->opt_settings->section : $xml->opt_settings;
		foreach ($sections_node as $section) {
			foreach ($section->item as $item) {
				if (!empty($item->name)) { // options
					if (isset($options[(string)$item['id']]) && !in_array((string)$item['id'], $rewrite_opts)) {
						continue;
					}
					if ((string)$item->type != 'header') {
						if (isset($item->multilanguage)) {
							$options[(string)$item['id']] = '%ML%';

							$ml_option_value = array(
								'addon' => $addon,
								'object_id' => (string)$item['id'],
								'object_type' => 'L', // option value
								'description' => (string)$item->default_value
							);

							foreach ((array)Registry::get('languages') as $ml_option_value['lang_code'] => $_v) {
								$ml_option_value['description'] = isset($options[(string)$item['id']]) ? $options[(string)$item['id']] : (string)$item->default_value;
								foreach ($item->multilanguage->item as $v_item) {
									if ((string)$v_item['lang'] == $ml_option_value['lang_code']) {
										$ml_option_value['description'] = (string)$v_item;
									}
								}
								db_query("REPLACE INTO ?:addon_descriptions ?e", $ml_option_value);
							}
						} else {
							$options[(string)$item['id']] = isset($options[(string)$item['id']]) ? $options[(string)$item['id']] : (string)$item->default_value;
						}
					}

					$descriptions = array(
						'addon' => $addon,
						'object_id' => (string)$item['id'],
						'object_type' => 'O', //option
					);

					foreach ((array)Registry::get('languages') as $descriptions['lang_code'] => $_v) {
						$descriptions['description'] = (string)$item->name;

						if (isset($item->tooltip)) {
							$descriptions['tooltip'] = (string)$item->tooltip;
							if (isset($item->tt_translations)) {
								foreach ($item->tt_translations->item as $_item) {
									if ((string)$_item['lang'] == $descriptions['lang_code']) {
										$descriptions['tooltip'] = (string)$_item;
									}
								}
							}
						}
						if (isset($item->translations)) {
							foreach ($item->translations->item as $_item) {
								if ((string)$_item['lang'] == $descriptions['lang_code']) {
									$descriptions['description'] = (string)$_item;
								}
							}
						}
						db_query("REPLACE INTO ?:addon_descriptions ?e", $descriptions);
					}

					if (isset($item->variants)) {
						foreach ($item->variants->item as $vitem) {
							$descriptions = array(
								'addon' => $addon,
								'object_id' => (string)$vitem['id'],
								'object_type' => 'V', //variant
							);

							foreach ((array)Registry::get('languages') as $descriptions['lang_code'] => $_v) {
								$descriptions['description'] = (string)$vitem->name;
								if (isset($vitem->translations)) {
									foreach ($vitem->translations->item as $_vitem) {
										if ((string)$_vitem['lang'] == $descriptions['lang_code']) {
											$descriptions['description'] = (string)$_vitem;
										}
									}
								}
								db_query("REPLACE INTO ?:addon_descriptions ?e", $descriptions);
							}
						}
					}
				}
			}
		}
		db_query("UPDATE ?:addons SET options = ?s WHERE addon = ?s", serialize($options), $addon);
	}

	$rewrite_vars = array();
	// Add optional language variables
	if (isset($xml->opt_language_variables)) {
		$cache = array();
		foreach ($xml->opt_language_variables->item as $v) {
			$descriptions = array(
				'lang_code' => (string)$v['lang'],
				'name' => (string)$v['id'],
				'value' => (string)$v,
			);

			$cache[$descriptions['name']][$descriptions['lang_code']] = $descriptions['value'];

			$row = db_get_field("SELECT name FROM ?:language_values WHERE name = ?s AND lang_code = ?s", $descriptions['name'], $descriptions['lang_code']);
			if (empty($row)) {
				db_query("INSERT INTO ?:language_values ?e", $descriptions);
			} elseif (in_array($row, $rewrite_vars)) {
				db_query("REPLACE INTO ?:language_values ?e", $descriptions);
			}
		}

		// Add variables for missed languages
		$_all_languages = Registry::get('languages');
		$_all_languages = array_keys($_all_languages);
		foreach ($cache as $n => $lcs) {
			$_lcs = array_keys($lcs);

			$missed_languages = array_diff($_all_languages, $_lcs);
			if (!empty($missed_languages)) {
				$descriptions = array(
					'name' => $n,
					'value' => $lcs['EN'],
				);

				foreach ($missed_languages as $descriptions['lang_code']) {
					$row = db_get_field("SELECT name FROM ?:language_values WHERE name = ?s AND lang_code = ?s", $descriptions['name'], $descriptions['lang_code']);
					if (empty($row)) {
						db_query("REPLACE INTO ?:language_values ?e", $descriptions);
					}
				}
			}
		}
	}

	// Install templates
	$areas = array('customer', 'admin', 'mail');
	$installed_skins = fn_get_dir_contents(Registry::get('config.dir.skins'));
//	foreach ($installed_skins as $skin_name) {
//		foreach ($areas as $area) {
//			if (is_dir(Registry::get('config.dir.skins')_REPOSITORY . 'base/' . $area . '/addons/' . $addon)) {
//				fn_rm(Registry::get('config.dir.skins') . $skin_name . '/' . $area . '/addons/' . $addon);
//				fn_copy(Registry::get('config.dir.skins')_REPOSITORY . 'base/' . $area . '/addons/' . $addon, Registry::get('config.dir.skins') . $skin_name . '/' . $area . '/addons/' . $addon);
//			}
//		}
//	}

	$data = array(
		'option_name' => 'review_attributes_version',
		'option_type' => 'I',
		'value' => REVIEW_ATTRIBUTES_VERSION
	);
	db_query("REPLACE INTO ?:settings ?e", $data);

	fn_rm(DIR_COMPILED, false);
	fn_rm(DIR_CACHE, false);
	Registry::cleanup();

	fn_set_notification('N', __('notice'), __('upgrade_completed'));

	return array(CONTROLLER_STATUS_REDIRECT, "review_attributes.manage");
}
?>