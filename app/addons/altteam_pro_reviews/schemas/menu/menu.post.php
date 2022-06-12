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

$schema['central']['website']['items']['global_review_attributes'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'review_attributes.manage',
    'position' => 701,
    'subitems' => array(
        'manage_attributes' => array(
            'href' => 'review_attributes.manage',
            'position' => 702
        ),
        'apply_attr_to_product' => array(
            'href' => 'review_attributes.apply',
            'position' => 703
        ),
    )
);

return $schema;
