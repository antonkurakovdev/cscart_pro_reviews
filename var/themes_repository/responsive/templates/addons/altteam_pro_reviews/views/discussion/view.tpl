{if $_REQUEST.dispatch == 'products.view'}
	{assign var="discussion" value=$object_id|fn_get_discussion:$object_type:true:$smarty.request}

	{assign var="posts" value=$discussion.posts}

	{if $discussion && $discussion.type != "D"}
	<div id="content_review_attributes">

	{if $discussion.object_type == 'E'}
		{assign var="posts" value=0|fn_get_review_posts:$smarty.request.page|fn_get_likes}
	{else}
		{assign var="posts" value=$discussion.thread_id|fn_get_review_posts:$smarty.request.page|fn_get_likes}
	{/if}

	{* if object is product then get attributes and ratings *}
	{assign var="attributes" value=$object_id|fn_get_review_attributes_work}
	{if $object_type == 'P' && $attributes}
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings}
	{* get just average value for thread *}
	{else}
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings:true}
	{/if}

	{if !$ratings || $ratings.average == 0.00 && !$ratings.rating}
		{assign var="ratings" value=$discussion.thread_id|fn_get_review_ratings:true}
	{/if}

	
	{assign var="total_recommended" value=0}
	{if $posts|@count > 0}
		{foreach from=$posts item=post}
			{if $post.is_recommended === 'Y'}
				{$total_recommended = $total_recommended + 1}
			{/if}
		{/foreach}
		{math assign="total_recommended_percent" equation="100 / (x / y)" x=$posts|@count y=$total_recommended}
	{/if}
	
	<div class="at-pro">
		{if ($discussion.type == "R" || $discussion.type == "B") && $ratings}

		<div class="at-pro__summary">
			{if $addons.altteam_pro_reviews.enable_recommendation == 'Y' && $posts}
				<div class="at-pro__summary-top">
					<span class="at-pro__summary-title">
						{$discussion.posts|@count} 
						{if $discussion.posts|@count == 1}
							{__("one_review")} 
						{/if}
						{if $discussion.posts|@count >= 2 && $discussion.posts|@count <= 4}
							{__("several_reviews")} 
						{/if}
						{if $discussion.posts|@count > 4}
							{__("pro_many_reviews")} 
						{/if}
					</span>
					<div class="at-pro__reccomended"><span class="at-pro__reccomended-value">{$total_recommended_percent|ceil}%</span> {__("reccomended_this_item")}</div>
				</div>
			{/if}
			{if $posts}
			<div class="at-pro__summary-wrap">
				<div class="at-pro__summary-attrs">
					{foreach from=$attributes item="attribute"}
					<div class="at-pro__summary-attrs-one">
						<div class="at-pro__summary-attrs-label">{$attribute.attr_name}</div>
						<div class="at-pro__summary-attrs-value">
							{assign var="attr_id" value=$attribute.attr_id}
							{include file="addons/altteam_pro_reviews/views/discussion/components/stars.tpl" stars=$ratings.average_by_attr.$attr_id.value|fn_get_discussion_rating}&nbsp;{$ratings.average_by_attr.$attr_id.percent}
						</div>
					</div>
					{/foreach}
				</div>
				{if $addons.altteam_pro_reviews.enable_chart == 'Y'}
				<div class="at-pro__summary-charts">
					{math assign="total_percent" equation="100 / (x / y)" x=5 y=$discussion.average_rating}
					<div class="chart" data-percent="{$total_percent}" data-bar-color="{$addons.altteam_pro_reviews.pie_chart}" data-scale-color="{$addons.altteam_pro_reviews.pie_chart}">
						<span class="percent"></span>
					</div>
				</div>
				{/if}
				{if $addons.altteam_pro_reviews.enable_summary_notice == 'Y'}
				<div class="at-pro__summary-notice">{__("pro_summary_notice")}</div>
				{/if}
			</div>
			{/if}
		</div>
		{/if}

	
		<div class="at-pro__controls" id="pro_sort_bar_{$object_id}">
			{if "CRB"|strpos:$discussion.type !== false && !$discussion.disable_adding}
			<div class="at-pro__controls-left">
				{include file="buttons/button.tpl" but_id="opener_new_post" but_text=__("write_your_review") but_role="submit" but_target_id="new_extended_post_dialog" but_meta="ty-btn__primary cm-dialog-opener cm-dialog-auto-size"}
				{include file="addons/altteam_pro_reviews/views/discussion/components/new_post.tpl" new_post_title=$new_post_title}
			</div>
			{/if}
			{if $addons.altteam_pro_reviews.enable_sorting == 'Y' && $posts}
				<div class="at-pro__controls-right">
					<div class="ty-sort-dropdown">
						<a id="sw_sort_reviews" class="ty-sort-dropdown__wrapper cm-combination">
							{if $_REQUEST.sort_review == 'MH'}<i class="fas fa-sort-amount-down-alt"></i>{__('most_helpful_first')}{/if}
							{if $_REQUEST.sort_review == 'HR'}<i class="fas fa-sort-amount-down-alt"></i>{__('highest_rating_first')}{/if}
							{if $_REQUEST.sort_review == 'LR'}<i class="fas fa-sort-amount-down-alt"></i>{__('lowest_rating_first')}{/if}
							{if $_REQUEST.sort_review == 'NW' || !$_REQUEST.sort_review}<i class="fas fa-sort-amount-down-alt"></i>{__('newest_first')}{/if}
							{if $_REQUEST.sort_review == 'OD'}<i class="fas fa-sort-amount-down-alt"></i>{__('oldest_first')}{/if}
							{*{if $_REQUEST.sort_review == 'ORC'}<i class="fas fa-award"></i>{__('only_real_customers')}{/if}*}
							{if $_REQUEST.sort_review == 'OR' && $addons.altteam_pro_reviews.enable_recommendation == 'Y'}<i class="fas fa-thumbs-up"></i>{__('only_recommended')}{/if}
							<i class="fas fa-chevron-down"></i>
							<i class="fas fa-chevron-up"></i>
						</a>
						<ul id="sort_reviews" class="ty-sort-dropdown__content cm-popup-box hidden">
	 						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'MH'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=MH&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-sort-amount-down-alt"></i>{__('most_helpful_first')}</a>
	 						</li>
	  						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'HR'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=HR&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-sort-amount-down-alt"></i>{__('highest_rating_first')}</a>
	 						</li>
	   						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'LR'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=LR&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-sort-amount-down-alt"></i>{__('lowest_rating_first')}</a>
	 						</li>
	  						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'NW' || !$_REQUEST.sort_review}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=NW&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-sort-amount-down-alt"></i>{__('newest_first')}</a>
	 						</li>
	   						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'OD'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=OD&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-sort-amount-down-alt"></i>{__('oldest_first')}</a>
	 						</li>
	   						{*<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'ORC'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=ORC&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-award"></i>{__('only_real_customers')}</a>
	 						</li>*}
	 						{if $addons.altteam_pro_reviews.enable_recommendation == 'Y'}
	   						<li class="ty-sort-dropdown__content-item {if $_REQUEST.sort_review == 'OR'}active{/if}">
	 							 <a class="cm-ajax ty-sort-dropdown__content-item-a" data-ca-target-id="pagination_contents_comments*, pro_sort_bar*" href="{"products.view&product_id=`$object_id`&sort_review=OR&selected_section=review_attributes"|fn_url}" rel="nofollow"><i class="fas fa-thumbs-up"></i>{__('only_recommended')}</a>
	 						</li>
	 						{/if}
						</ul>
					</div>
				</div>
			{/if}
			<!--pro_sort_bar_`$object_id`-->
		</div>

		<div class="at-pro__posts">
			{include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`"}
			<div class="at-pro__posts-wrap">
				{foreach from=$posts item=post}
					<div class="at-pro__posts-one {if $post.admin_response && $addons.altteam_pro_reviews.enable_admin_answer == 'Y'}with-admin-response{/if}">
						<div class="at-pro__posts-one-image">
							<span class="at-pro__posts-one-image-text">{$post.name|truncate:1:""}</span>
						</div>
						<div class="at-pro__posts-one-content">
							<div class="at-pro__posts-one-name">
								{$post.name|escape}
								<span class="at-pro__posts-one-date">{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</span>
							</div>
							<div class="at-pro__posts-one-rating">
								<div class="at-pro__posts-one-rating-val">{$post.rating_value}</div>
								{if ($discussion.type == "R" || $discussion.type == "B") && $attributes}
								{assign var="post_id" value=$post.post_id}

								<div class="at-pro__posts-one-rating-attrs">
									{foreach from=$attributes item="attribute"}
									<div class="at-pro__posts-one-rating-attrs-one">
										<div class="at-pro__posts-one-rating-attrs-one-label">{$attribute.attr_name}</div>
										<div class="at-pro__posts-one-rating-attrs-one-value">
											{assign var="attr_id" value=$attribute.attr_id}
											{include file="addons/altteam_pro_reviews/views/discussion/components/stars.tpl" stars=$ratings.rating.$post_id.$attr_id|fn_get_discussion_rating}
										</div>
									</div>
									{/foreach}
								</div>
								{/if}

								{if $addons.altteam_pro_reviews.enable_recommendation == 'Y'}
								<div class="at-pro__posts-one-reccomended {if $post.is_recommended === 'Y'}up{else}down{/if}">
									{if $post.is_recommended === 'Y'}
										<i class="far fa-thumbs-up"></i>
										{__("customer_reccomended")}
									{else}
										<i class="far fa-thumbs-down"></i>
										{__("customer_not_reccomended")}
									{/if}
								</div>
								{/if}
								{if $post.is_secure_review && $addons.altteam_pro_reviews.enable_real_customer == 'Y'}
								<div class="at-pro__posts-one-real" title="{__('real_customer_notice')}">
									<i class="fas fa-award"></i>
									{__("real_customer")}
								</div>
								{/if}

							</div>

							{if $post.message_title && $addons.altteam_pro_reviews.enable_title == 'Y'}
							<div class="at-pro__posts-one-control">
								<div class="at-pro__posts-one-control-label">{__("usage_time")}</div>
								<div class="at-pro__posts-one-control-value">{$post.message_title}</div>
							</div>
							{/if}

							{if $addons.altteam_pro_reviews.enable_advantages == 'Y'}
								{if $post.plus}
								<div class="at-pro__posts-one-control">
									<div class="at-pro__posts-one-control-label">{__("pro_plus")}</div>
									<div class="at-pro__posts-one-control-value">{$post.plus}</div>
								</div>
								{/if}
								{if $post.minus}
								<div class="at-pro__posts-one-control">
									<div class="at-pro__posts-one-control-label">{__("pro_minus")}</div>
									<div class="at-pro__posts-one-control-value">{$post.minus}</div>
								</div>
								{/if}
							{/if}

							{if $discussion.type == "C" || $discussion.type == "B"}
							<div class="at-pro__posts-one-control">
								<div class="at-pro__posts-one-control-label">{__("review")}</div>
								<div class="at-pro__posts-one-control-value">{$post.message|escape|nl2br nofilter}</div>
							</div>
							{/if}

							{if $addons.altteam_pro_reviews.enable_likes == 'Y'}
								<div class="at-pro__posts-one-likes">
									{if $auth.user_id}
										<a class="cm-ajax" href="{"review_attributes.likes&like=1&post_id=`$post.post_id`"|fn_url}">
											<i class="far fa-thumbs-up"></i>
											<span>{$post.likes.yes|default:0}</span>
										</a>
										<a class="cm-ajax" href="{"review_attributes.likes&like=0&post_id=`$post.post_id`"|fn_url}">
											<i class="far fa-thumbs-down"></i>
											<span>{$post.likes.no|default:0}</span>
										</a>
									{else}
										<a class="cm-ajax" href="{"auth.login_form&return_url=`$escaped_current_url`"|fn_url}">
											<i class="far fa-thumbs-up"></i>
											<span>{$post.likes.yes|default:0}</span>
										</a>
										<a class="cm-ajax" href="{"auth.login_form&return_url=`$escaped_current_url`"|fn_url}">
											<i class="far fa-thumbs-down"></i>
											<span>{$post.likes.no|default:0}</span>
										</a>
									{/if}
								</div>
							{/if}
						</div>
					</div>
					{if $post.admin_response && $addons.altteam_pro_reviews.enable_admin_answer == 'Y'}
						<div class="at-pro__posts-one admin">
							<div class="at-pro__posts-one-image" style="background: url({$logos.theme.image.image_path}) center no-repeat;background-size: 85%;">
							</div>
							<div class="at-pro__posts-one-content">
								<div class="at-pro__posts-one-name">
									<i class="fas fa-users-cog"></i> {__("admin_response")}
								</div>
								<div class="at-pro__posts-one-content">
									<div class="at-pro__posts-one-control">
										<div class="at-pro__posts-one-control-value">{$post.admin_response}</div>
									</div>								
								</div>
							</div>
						</div>
					{/if}
				{/foreach}
			</div>
			{include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`"}
		</div>

	</div>

	<!--content_review_attributes--></div>

	{/if}
{/if}