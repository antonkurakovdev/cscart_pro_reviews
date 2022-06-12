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

if ( !defined('BOOTSTRAP') ) { die('Access denied'); }

if($mode == 'likes'){
	if ($auth['user_id'] && isset($_REQUEST['post_id'])){
		$data = array();
		$data['user_id'] = $auth['user_id'];
		$data['post_id'] = $_REQUEST['post_id'];
		$data['is_like'] = $_REQUEST['like'];
		$vote = db_get_field('SELECT is_like FROM ?:review_likes WHERE user_id=?i AND post_id=?i', $data['user_id'], $data['post_id']);
		if($vote !== $data['is_like']){
			$_data = fn_check_table_fields($data, 'review_likes');
			db_query('REPLACE INTO ?:review_likes ?e', $data);
			$title = $data['is_like'] ? __('you_like_this') : __('you_not_like_this');
			$msg = __('thanks_for_vote');
			fn_set_notification('N', $title, $msg);
		}else{
			fn_set_notification('E', __('error'), __('no_more_vote'), 'I');
		}
	}
	exit;
}
?>