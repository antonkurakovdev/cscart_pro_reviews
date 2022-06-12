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

?>