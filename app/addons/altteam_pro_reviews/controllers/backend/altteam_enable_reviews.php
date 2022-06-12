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


if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Registry;

if ($mode == 'change') {

    fn_echo("Start!");
    fn_echo("<br /><br />");

    $reviews_status = Registry::get('addons.discussion.status');

    if (empty($reviews_status)) {

        fn_echo("Please, install the 'Comments and reviews' add-on");
        die();

    }

    $available_status = array("B", "C", "R", "D");

    if (in_array($action, $available_status)) {

        $object_ids = db_get_fields("SELECT object_id FROM ?:discussion WHERE object_type = ?s", "P");
        // $product_ids = db_get_fields("SELECT product_id FROM ?:products");
        $product_ids = db_get_hash_array("SELECT product_id, company_id FROM ?:products", 'product_id');

        //  All products
        fn_echo("Prepared:" . count($product_ids));
        fn_echo("<br /><br />");

        db_query("UPDATE ?:discussion SET ?u WHERE object_type = ?s", array('type' => $action), "P");

        //  Update products
        fn_echo("Update:" . count($object_ids));
        fn_echo("<br /><br />");

        //  Remove updated products
        foreach ($object_ids as $key) {
            unset($product_ids[$key]);
        }

        if (!empty($product_ids)) {

            if (! (isset($company_id) && $company_id) ) {
            
                //  checked company
                if ( Registry::get('runtime.company_id') ) {
                    $company_id = Registry::get('runtime.company_id');
                //  single company
                } elseif ( Registry::get('runtime.forced_company_id') ) {
                    $company_id = Registry::get('runtime.forced_company_id');
                //  use for all company
                } else {
                    $company_id = 0;
                    $use_for_all_company = true;
                }

            }


            $data = array (
                'object_type' => 'P',
                'type' => $action,
                'company_id' => $company_id
            );

            $statistic_update = 0;

            if (!$use_for_all_company) {
                foreach ($product_ids as $data['object_id'] => $product) {
                    if ($product['company_id'] = $company_id) {
                        
                        $data['object_id'] = $product['product_id'];
                        db_query("INSERT INTO ?:discussion ?e", $data);

                        $statistic_update++;
                    }
                }

            } else {

                list($companies) = fn_get_companies(array(), $auth);

                if (!empty($companies)) {
                    foreach ($companies as $company) {
                        
                        $company_id = $data['company_id'] = $company['company_id'];
    
                        foreach ($product_ids as $data['object_id'] => $product) {
                            if ($product['company_id'] = $company_id) {
                            
                                $data['object_id'] = $product['product_id'];
                                db_query("INSERT INTO ?:discussion ?e", $data);
                                
                                $statistic_update++;
                            }
                        }

                        fn_echo("Update for company " . $company['company'] . " finished.");
                        fn_echo("<br /><br />");
                    }
                }
            }

            //  Insert products
            fn_echo("Insert:" . count($product_ids));
            fn_echo("<br /><br />");

        }

    } else {
        fn_echo("Incorrect Status!");
    }


    fn_echo("Done!");
    exit();

} elseif ($mode == 'set_default') {

    fn_echo("Start!");
    fn_echo("<br /><br />");

    $reviews_status = Registry::get('addons.discussion.status');

    if (empty($reviews_status)) {

        fn_echo("Please, install the 'Comments and reviews' add-on");
        die();
    }

    $available_status = array("B", "C", "R", "D");

    if (in_array($action, $available_status)) {

        $_status = db_query("ALTER TABLE ?:discussion ALTER COLUMN `type` SET DEFAULT ?s", $action);

        if ($_status) {
            
            fn_echo("Set Default Status: " . $action);
            fn_echo("<br /><br />");
        }
  
    } else {

        fn_echo("Incorrect Status!");
        fn_echo("<br /><br />");

    }

    fn_echo("Done!");
    exit();

}