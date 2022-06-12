{*{if $product.discussion_type && $product.discussion_type != 'D'}
    <div class="rating-wrapper clearfix" id="average_rating_product_{$obj_prefix}{$obj_id}">
        {assign var="rating" value="rating_`$obj_id`"}{$smarty.capture.$rating nofilter}

        {if $product.discussion.posts}
        <a  href="{"products.view?product_id=`$product.product_id`&selected_section=discussion#discussion"|fn_url}">{$product.discussion.posts|count} {__("reviews", [$product.discussion.posts|count])}</a>
        {/if}
        <a class="cm-dialog-opener cm-dialog-auto-size" data-ca-target-id="new_post_dialog_{$obj_prefix}{$obj_id}" rel="nofollow">{__("write_review")}</a>
    <!--average_rating_product_{$obj_prefix}{$obj_id}--></div>
{/if}
*}