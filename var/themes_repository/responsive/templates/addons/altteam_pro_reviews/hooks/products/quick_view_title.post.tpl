{if $product.discussion_type && $product.discussion_type != 'D'}

{assign var="attributes" value=$product.product_id|fn_get_review_attributes_work}

{if $attributes}

	{assign var="ratings" value=$product.discussion.thread_id|fn_get_review_ratings}

    <div class="ty-discussion__rating-wrapper clearfix" id="average_rating_product_{$obj_prefix}{$obj_id}">

		{if $ratings.average}

			<a  href="{"products.view?product_id=`$product.product_id`&selected_section=review_attributes#review_attributes"|fn_url}">
				{include file="addons/altteam_pro_reviews/views/discussion/components/stars.tpl" stars=$ratings.average|fn_get_discussion_rating stars_mode=big}
			</a>

    	    <a  href="{"products.view?product_id=`$product.product_id`&selected_section=review_attributes#review_attributes"|fn_url}" class="ty-discussion__review-a">{$ratings.count} {__("reviews", [$ratings.count])}</a>

        {/if}

		<a  href="{"products.view?product_id=`$product.product_id`&selected_section=review_attributes#review_attributes"|fn_url}">{__("write_review")}</a>

    <!--average_rating_product_{$obj_prefix}{$obj_id}--></div>

{else}

    <div class="ty-discussion__rating-wrapper clearfix" id="average_rating_product_{$obj_prefix}{$obj_id}">
        {assign var="rating" value="rating_`$obj_id`"}{$smarty.capture.$rating nofilter}

        {if $product.discussion.posts}
        <a href="{"products.view?product_id=`$product.product_id`&selected_section=discussion#discussion"|fn_url}" class="ty-discussion__review-a">{$product.discussion.search.total_items} {__("reviews", [$product.discussion.search.total_items])}</a>
        {/if}
        <a class="ty-discussion__review-write cm-dialog-opener cm-dialog-auto-size" data-ca-target-id="new_post_dialog_{$obj_prefix}{$obj_id}" rel="nofollow">{__("write_review")}</a>
    <!--average_rating_product_{$obj_prefix}{$obj_id}--></div>

{/if}
{/if}