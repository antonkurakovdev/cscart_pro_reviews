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

if ($mode == 'manage') {
	$posts = Registry::get('view')->getTemplateVars('posts');

	$ids = array();
	foreach($posts as $k => $v){
		$ids[] = $v['post_id'];

		//get review attributes available for each post
		if (($v['type'] == 'R' || $v['type'] == 'B') && $v['object_type'] == 'P'){
			$posts[$k]['attributes'] = fn_get_review_attributes($v['object_id']);
		}
	}

	//get rating values for each post
	$ratings = db_get_hash_multi_array('SELECT post_id, attr_id, rating FROM ?:review_rating WHERE post_id IN (?n)', array('post_id', 'attr_id', 'rating'), $ids);
	foreach($posts as $k => $post){
		if (isset($post['attributes'])){
			foreach($post['attributes'] as $key => $attribute){
				$posts[$k]['attributes'][$key]['value'] = isset($ratings[$post['post_id']][$attribute['attr_id']]) ? $ratings[$post['post_id']][$attribute['attr_id']] : 0;
			}
		}
	}

	//get additional field message title
	$_titles = db_get_array('SELECT post_id, message_title, plus, minus, admin_response FROM ?:discussion_messages WHERE post_id IN (?n)', $ids);
	foreach($_titles as $v){
		$titles[$v['post_id']] = $v['message_title'];
		$titles[$v['post_id']] = $v['plus'];
		$titles[$v['post_id']] = $v['minus'];
		$titles[$v['post_id']] = $v['admin_response'];
	}
	foreach ($posts as $k => $v){
		if(isset($titles[$v['post_id']])){
			$posts[$k]['message_title'] = $titles[$v['post_id']];
			$posts[$k]['plus'] = $titles[$v['post_id']];
			$posts[$k]['minus'] = $titles[$v['post_id']];
			$posts[$k]['admin_response'] = $titles[$v['post_id']];
		}
	}

	Registry::get('view')->assign('posts', $posts);
}
?>