{assign var="addon_images_path" value="`$images_dir`/addons/altteam_pro_reviews/images/"}

{if $attributes}
<div class="review-rating clearfix">
	<table cellpadding="0" cellspacing="0" class="rating-table">
		<tr>
			<th>&nbsp;</th>
			<th><fieldset class="rating"><input type="radio" checked /><label></label></fieldset></th>
			<th><fieldset class="rating"><input type="radio" checked /><label></label></fieldset></th>
			<th><fieldset class="rating"><input type="radio" checked /><label></label></fieldset></th>
			<th><fieldset class="rating"><input type="radio" checked /><label></label></fieldset></th>
			<th><fieldset class="rating"><input type="radio" checked /><label></label></fieldset></th>
			<th>&nbsp;</th>
		</tr>
		{foreach from=$post.attributes item="attribute" name="attr"}
		<tr>
			<td class="right gray-line">{$attribute.attr_name}&nbsp;=&nbsp;</td>
			<td class="valign review-star-rate"><input type="radio" name="posts[{$post.post_id}][attributes][{$attribute.attr_id}]" value="1" {if $attribute.value == 1}checked="checked"{/if} /></td>
			<td class="valign review-star-rate"><input type="radio" name="posts[{$post.post_id}][attributes][{$attribute.attr_id}]" value="2" {if $attribute.value == 2}checked="checked"{/if}/></td>
			<td class="valign review-star-rate"><input type="radio" name="posts[{$post.post_id}][attributes][{$attribute.attr_id}]" value="3" {if $attribute.value == 3}checked="checked"{/if}/></td>
			<td class="valign review-star-rate"><input type="radio" name="posts[{$post.post_id}][attributes][{$attribute.attr_id}]" value="4" {if $attribute.value == 4}checked="checked"{/if}/></td>
			<td class="valign review-star-rate"><input type="radio" name="posts[{$post.post_id}][attributes][{$attribute.attr_id}]" value="5" {if $attribute.value == 5}checked="checked"{/if}/></td>
			<td class="attr_val gray-line"> (<span id="value_attr_row_{$smarty.foreach.attr.iteration}">{$attribute.value|default:1}</span> {__('stars')})</td>
		</tr>
		{/foreach}
	</table>
	<script type="text/javascript">
		post_id = {$post.post_id};
		{literal}
		$(document).ready(function(){
			$('td.review-star-rate input').click(function(){
				val = $(this).attr('value');
				$(this).parent().siblings('.attr_val').find('span').html(val);
			});
		});
		{/literal}
	</script>
</div>
{else}
    {include file="addons/discussion/views/discussion_manager/components/rate.tpl" rate_id="rating_`$post.post_id`" rate_value=$post.rating_value rate_name="posts[`$post.post_id`][rating_value]"}
{/if}