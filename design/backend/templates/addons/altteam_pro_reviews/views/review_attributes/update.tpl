<form action="{""|fn_url}" method="post" name="global_review_attributes_form" class="form-highlight cm-disable-empty-files cm-ajax" enctype="multipart/form-data">
	<input type="hidden" name="result_ids" value="global_attributes_list" />
	<input type="hidden" name="product_id" value="{$product_data.product_id}" />
	{if $redirect_url}
		<input type="hidden" name="redirect_url" value="{$redirect_url}" />
	{/if}
	<fieldset>
		<table cellpadding="0" cellspacing="0" class="table table-tree table-middle table--relative">
		<thead>
			<tr>
				<th width="5%" class="cm-non-cb">{__('position_short')}</th>
				<th width="85%" class="cm-non-cb">{__('attribute')}</th>
				{if $mark_global}<th class="cm-non-cb center">{__('global')}</th>{/if}
				<th width="10%" class="cm-non-cb">&nbsp;</th>
			</tr>
		</thead>
		{foreach from=$review_attributes item="attr" name="attr"}
		{assign var="num" value=$smarty.foreach.attr.iteration}
		<tbody class="hover cm-row-item" id="review_attributes_{$num}">
		<tr>
			<td width="5%" class="cm-non-cb">
				<input type="hidden" name="review_attributes[{$num}][attr_id]" value="{$attr.attr_id}" />
				<input type="hidden" name="review_attributes[{$num}][object_id]" value="{$attr.object_id|default:0}" />
				<input type="text" name="review_attributes[{$num}][position]" value="{$attr.position}" size="3" class="input-micro" /></td>
			<td width="85%" class="cm-non-cb">
				<input type="text" name="review_attributes[{$num}][attr_name]" value="{$attr.attr_name}" class="input-text main-input" /></td>
			{if $mark_global}
			<td class="cm-non-cb valign center">
				{if !$attr.object_id}+{else}-{/if}</td>
			{/if}
			<td width="10%" class="right cm-non-cb">
				{include file="buttons/multiple_buttons.tpl" item_id="review_attribute_`$num`" tag_level="1" only_delete='Y'}
			</td>
		</tr>
		</tbody>
		{/foreach}
		{math equation="x + 1" assign="num" x=$num|default:0}{assign var="vr" value=""}
		<tbody class="hover cm-row-item" id="box_add_attribute">
		<tr>
			<td class="cm-non-cb">
				<input type="text" name="review_attributes[{$num}][position]" value="0" size="3" class="input-micro" /></td>
			<td class="cm-non-cb">
				<input type="text" name="review_attributes[{$num}][attr_name]" value="" class="input-text main-input" /></td>
			{if $mark_global}
			<td class="cm-non-cb" class="valign"></td>
			{/if}
			<td class="right cm-non-cb">
				{include file="buttons/multiple_buttons.tpl" item_id="add_attribute" tag_level="1"}
			</td>
		</tr>
		</tbody>
		</table>
	</fieldset>

</form>