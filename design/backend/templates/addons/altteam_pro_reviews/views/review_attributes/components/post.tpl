{assign var="current_redirect_url" value=$config.current_url|escape:url}
{if $_REQUEST.dispatch == 'products.update'}
	{assign var="post" value=$post|fn_get_post_title|fn_get_post_attributes:$_REQUEST.product_id}
	{assign var="attributes" value=$_REQUEST.product_id|fn_get_review_attributes_work}
{/if}

<div class="summary">
    <input placeholder="{__('name')}" type="text" name="posts[{$post.post_id}][name]" value="{$post.name}" size="40" class="input-hidden">
	{if $addons.altteam_pro_reviews.enable_title == 'Y'}
        <input placeholder="{__('usage_time')}" type="text" name="posts[{$post.post_id}][message_title]" class="input-hidden" value="{$post.message_title}" />
    {/if}
    {if $addons.altteam_pro_reviews.enable_advantages == 'Y'}
        <input placeholder="{__('pro_plus')}" type="text" name="posts[{$post.post_id}][plus]" class="input-hidden" value="{$post.plus}" />
        <input placeholder="{__('pro_minus')}" type="text" name="posts[{$post.post_id}][minus]" class="input-hidden" value="{$post.minus}" />
    {/if}
    {hook name="discussion:update_post"}
        {if $type == "C" || $type == "B"}
            <textarea placeholder="{__('message')}" name="posts[{$post.post_id}][message]" cols="80" rows="5" class="input-hidden">{$post.message}</textarea>
            {if $addons.altteam_pro_reviews.enable_admin_answer == 'Y'}
                <textarea placeholder="{__('admin_response')}" name="posts[{$post.post_id}][admin_response]" cols="80" rows="5" class="input-hidden">{$post.admin_response}</textarea>
            {/if}
        {/if}
    {/hook}
</div>
<div class="tools">
    <div class="pull-left">
        {if "discussion.m_delete"|fn_check_view_permissions}
            <input type="checkbox" name="delete_posts[{$post.post_id}]" id="delete_checkbox_{$post.post_id}"  class="pull-left cm-item" value="Y">
        {/if}
        <div class="hidden-tools pull-left cm-statuses">
            {if "discussion.update"|fn_check_view_permissions}
                <span class="cm-status-a {if $post.status == "D"}hidden{/if}">
                    <span class="label label-success">{__("approved")}</span>
                    <a class="cm-status-switch icon-thumbs-down cm-tooltip" title="{__("disapprove")}" data-ca-status="D" data-ca-post-id="{$post.post_id}"></a>
                </span>
                <span class="cm-status-d {if $post.status == "A"}hidden{/if}">
                    <span class="label label-important">{__("not_approved")}</span>
                    <a class="cm-status-switch icon-thumbs-up cm-tooltip" title="{__("approve")}" data-ca-status="A" data-ca-post-id="{$post.post_id}"></a>
                </span>
            {else}
                <span class="cm-status-{$post.status|lower}">
                    {if $post.status == "A"}
                        <span class="label label-success">{__("approved")}</span>
                    {else}
                        <span class="label label-important">{__("not_approved")}</span>
                    {/if}
                </span>
            {/if}
            {if "discussion.delete"|fn_check_view_permissions}
                <a class="icon-trash cm-tooltip cm-confirm" href="{"discussion.delete?post_id=`$post.post_id`&redirect_url=`$current_redirect_url`"|fn_url}" title="{__("delete")}"></a>
            {/if}
        </div>
    </div>


    <div class="pull-right">
        <span class="muted">{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"} / {__("ip_address")}:&nbsp;{$post.ip_address}</span>

        {if $type == "R" || $type == "B"}
			{include file="addons/altteam_pro_reviews/views/review_attributes/components/rate.tpl" rate_id="rating_`$post.post_id`" rate_value=$post.rating_value rate_name="posts[`$post.post_id`][rating_value]"}
        {/if}
    </div>

    {if $show_object_link}
        <a href="{$post.object_data.url|fn_url}" class="post-object" title="{$post.object_data.description}">{$post.object_data.description}</a>
    {/if}
</div>
