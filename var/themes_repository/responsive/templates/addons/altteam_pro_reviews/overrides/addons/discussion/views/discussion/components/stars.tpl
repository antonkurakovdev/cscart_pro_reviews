<span class="ty-nowrap ty-stars">
    {if $link}
        {if ($runtime.controller == "products" || $runtime.controller == "companies") && $runtime.mode == "view"}
            <a class="cm-external-click" data-ca-scroll="{if $runtime.controller == "products" }content_review_attributes{else}content_discussion{/if}" data-ca-external-click-id="{if $runtime.controller == "products" }review_attributes{else}discussion{/if}">
        {else}
            <a href="{$link|fn_url}">
        {/if}
    {/if}

    {section name="full_star" loop=$stars.full}
        <i class="ty-stars__icon ty-icon-star"></i>
    {/section}

    {if $stars.part}
        <i class="ty-stars__icon ty-icon-star-half"></i>
    {/if}

    {section name="full_star" loop=$stars.empty}
        <i class="ty-stars__icon ty-icon-star-empty"></i>
    {/section}

    {if $link}
        </a>
    {/if}
</span>
