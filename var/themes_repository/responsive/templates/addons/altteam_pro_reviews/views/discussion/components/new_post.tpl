<div class="hidden" id="new_extended_post_dialog" title="{__('new_post')}">
<div>
<form action="{""|fn_url}" method="post" class="cm-ajax cm-form-dialog-closer posts-form" name="add_extended_post_form" id="add_extended_post_form">

{assign var="addon_images_path" value="`$images_dir`/addons/altteam_pro_reviews/images/"}

<input type="hidden" name="result_ids" value="posts_list,new_post">
<input type ="hidden" name="post_data[thread_id]" value="{$discussion.thread_id}" />
<input type ="hidden" name="redirect_url" value="{$config.current_url}" />
<input type="hidden" name="selected_section" value="" />

<div id="new_extended_post">

<div class="ty-control-group">
	<label for="dsc_name" class="ty-control-group__title cm-required">{__('your_name')}</label>
	<input type="text" id="dsc_name" name="post_data[name]" value="{if $auth.user_id}{$user_info.firstname} {$user_info.lastname}{elseif $discussion.post_data.name}{$discussion.post_data.name}{/if}" size="50" class="input-text ty-input-text-large" />
</div>

{if $addons.altteam_pro_reviews.enable_recommendation == 'Y'}
<div class="ty-control-group">
	<label class="ty-control-group__title">{__('is_recommended')}</label>

	<div class="control">
		<p>
			<input class="radio" type="radio" id="dsc_is_recommended_yes" name="post_data[is_recommended]" value="Y">
			<label for="dsc_is_recommended_yes">{__('yes')}</label>
		</p>
		<p>
			<input class="radio" type="radio" id="dsc_is_recommended_no" name="post_data[is_recommended]" value="N">
			<label for="dsc_is_recommended_no">{__('no')}</label>
		</p>
	</div>
</div>
{/if}

{if $addons.altteam_pro_reviews.enable_advantages == 'Y'}
<div class="ty-control-group">
	<label for="dsc_plus" class="ty-control-group__title cm-required">{__('pro_plus')}</label>
	<input type="text" id="dsc_plus" name="post_data[plus]" size="50" class="input-text ty-input-text-large" />
</div>

<div class="ty-control-group">
	<label for="dsc_minus" class="ty-control-group__title cm-required">{__('pro_minus')}</label>
	<input type="text" id="dsc_minus" name="post_data[minus]" size="50" class="input-text ty-input-text-large" />
</div>
{/if}

{if $addons.altteam_pro_reviews.enable_title == 'Y'}
<div class="control-group ty-control-group">
	<label class="ty-control-group__title" for="dsc_message_title">{__('usage_time')}</label>
	<input type="text" id="dsc_message_title" name="post_data[message_title]" value="{$discussion.post_data.message_title}" class="input-text ty-input-text-large">
</div>
{/if}


{if $discussion.type == "R" || $discussion.type == "B"}
<div class="control-group ty-control-group your-rating">
	{if $object_type != 'P' || !$attributes}
	    {$rate_id = "extended_rating_`$obj_prefix``$obj_id`"}
	    <label for="{$rate_id}" class="ty-control-group__title cm-required cm-multiple-radios">{__("your_rating")}</label>
	    {include file="addons/discussion/views/discussion/components/rate.tpl" rate_id=$rate_id rate_name="post_data[rating_value]"}
	{elseif $attributes}

	    <label for="dsc_rating" class="ty-control-group__title show-required-icon">{__("your_rating")}</label>
		<!-- <label for="dsc_rating" class="ty-control-group__title cm-required">{__('your_rating')}</label> -->

		<table id="dsc_rating" cellpadding="0" cellspacing="0" class="rating-table">
			{foreach from=$attributes item="attribute" name="attr"}
			<tr>
				<td class="right gray-line"><label for="{$attribute.attr_id}" class="ty-control-group__title cm-required cm-multiple-radios dissabled-required-icon">{$attribute.attr_name}: </label></td>
				<td class="right gray-line">{include file="addons/discussion/views/discussion/components/rate.tpl" rate_id=$attribute.attr_id rate_name="post_data[attributes][{$attribute.attr_id}]"}</td>

			</tr>
			{/foreach}
		</table>

	{else}
	{/if}
</div>
{/if}

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$('input[name^="post_data[attributes]"]').click(function(){
			val = $(this).attr('value');
			$(this).parent().siblings('.attr_val').find('span').html(val);
		});
	});
	{/literal}
</script>

{if $discussion.type == "C" || $discussion.type == "B"}

<div class="control-group ty-control-group">
	<label for="dsc_message" class="ty-control-group__title cm-required">{__('your_message')}</label>
	<textarea id="dsc_message" name="post_data[message]" class="input-textarea ty-input-textarea ty-input-text-large" rows="5" cols="72">{$discussion.post_data.message}</textarea>
</div>
{/if}


{include file="common/image_verification.tpl" option="discussion"}

<!--new_extended_post--></div>

<div class="buttons-container">
	{include file="buttons/button.tpl" but_text=__("submit") but_role="submit" but_name="dispatch[discussion.add_extended]" but_meta="cm-submit-closer"}
</div>

</form>
</div>
</div>
