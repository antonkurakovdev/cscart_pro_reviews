{*{assign var="attributes" value=$object_id|fn_get_review_attributes_work}
{assign var="average_rating" value=$object_id|fn_get_average_rating:$object_type}
{if $attributes}

	{assign var="rev_count" value=$object_id|fn_get_review_count:$object_type}
	{assign var="discussion" value=$object_id|fn_get_discussion:$object_type|fn_html_escape}

	{if $product.product_id && $attributes}	
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings}
	{else}
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings:true}
	{/if}

	{if $attributes && !$ratings || $ratings.average == 0.00 && !$ratings.rating}
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings:true}
	{/if}

	{if $ratings.average}
		{if $runtime.controller == "products" && $runtime.mode == "view"}<a style="text-decoration: none;" onclick="$('#review_attributes').click(); return false;">{/if}{include file="addons/altteam_pro_reviews/views/discussion/components/stars.tpl" stars=$ratings.average|fn_get_discussion_rating}{if $runtime.controller == "products" && $runtime.mode == "view"}</a>{/if}
		{if $runtime.controller == "products" && $runtime.mode == "view"}<a style="text-decoration: none;" onclick="$('#review_attributes').click(); return false;">{/if}<p>{$rev_count}&nbsp;{__('reviews')}</p>{if $runtime.controller == "products" && $runtime.mode == "view"}</a>{/if}
	{/if}
{else}
	{if $average_rating}
		{if $runtime.controller == "products" && $runtime.mode == "view"}<a onclick="$('#review_attributes').click(); return false;">{/if}{include file="addons/altteam_pro_reviews/views/discussion/components/stars.tpl" stars=$average_rating|fn_get_discussion_rating mode='big'}{if $runtime.controller == "products" && $runtime.mode == "view"}</a>{/if}
	{/if}
{/if}*}
{*{$addons.snippets.rewiews|fn_print_r}*}
{*{if $addons.snippets.rewiews == 'Y' || $addons.snippets.stars == 'Y'}
	{assign var="count_rewiews" value=$object_id|fn_get_discussion_count_reviews:$object_type}

	{if $average_rating}
		{if $details_page}
			<span itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
			{if $addons.snippets.stars == 'Y'}
				<meta itemprop="ratingValue" content="{$average_rating}" /> 
			{/if}
			{if $addons.snippets.rewiews == 'Y'}
				<meta itemprop="reviewCount" content="{$count_rewiews}" /> 
			{/if}
			</span>
		{/if}
	{/if}
{/if}*}