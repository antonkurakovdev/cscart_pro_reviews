{capture name="mainbox"}
<div id="global_attributes_list">

{include file="addons/altteam_pro_reviews/views/review_attributes/update.tpl"}

<!--global_attributes_list--></div>
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        {if !$smarty.request.product_id}<li>{btn type="list" text=__("apply_to_products") href="review_attributes.apply"}</li>{/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list}

    {include file="buttons/button.tpl" but_text=__("save") but_role="action" but_name="dispatch[review_attributes.update]" but_target_form="global_review_attributes_form" but_meta="cm-submit"}
{/capture}

{include file="common/mainbox.tpl" title=__("global_review_attributes") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}