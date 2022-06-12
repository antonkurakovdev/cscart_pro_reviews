<div class="clearfix cm-field-container">
    <div class="ty-rating" id="{$rate_id}">
        {foreach from =""|fn_get_discussion_ratings item="title" key="val" name="discussion_ratings"}
        {$item_rate_id = "`$rate_id`_`$val`"}
        <input type="radio" id="{$item_rate_id}" class="ty-rating__check" name="{$rate_name}" value="{$val}" {if $smarty.foreach.discussion_ratings.first}checked="checked"{/if} /><label class="ty-rating__label" for="{$item_rate_id}" title="{$title}">{$title}</label>
        {/foreach}
    </div>
</div>