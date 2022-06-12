{* © Alt-team: http://alt-team.com *}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" name="add_global_attributes" />

{include file="pickers/products/picker.tpl" input_name="apply_attributes[object_ids]" data_id="added_products" type="links" no_item_text=__("text_all_items_included")|replace:"[items]":__("products")}
	
{include file="common/subheader.tpl" title=__("select_attributes")}
{foreach from=$review_attributes item="attr"}
<p>
	<label class="label-html-checkboxes">
		<input class="html-checkboxes" type="checkbox" value="{$attr.attr_id}" name="apply_attributes[attributes][]" />
		{$attr.attr_name}
	</label>
</p>
{/foreach}

<div class="buttons-container buttons-bg">
	{include file="buttons/button.tpl" but_text=__("apply") but_name="dispatch[review_attributes.apply]" but_role="button_main"}

	<input type="hidden" name="apply_attributes[object_type]" value="P" />
</div>

</form>

{/capture}
{include file="common/mainbox.tpl" title=__("apply_to_products") content=$smarty.capture.mainbox tools=$smarty.capture.tools select_languages=$select_languages}
