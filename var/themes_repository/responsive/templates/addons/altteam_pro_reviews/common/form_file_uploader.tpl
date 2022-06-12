{$object_id=$image_object_id|default:"0"}
{$template_id="fileupload_template_"|uniqid}
{$thumbnail_width=$thumbnail_width|default:250}
{$thumbnail_height=$thumbnail_height|default:250}
{$post_max_size = $server_env->getIniVar("post_max_size")|fn_return_bytes/(1024*1024)}
{$upload_max_filesize = $server_env->getIniVar("upload_max_filesize")|fn_return_bytes/(1024*1024)}
{$existing_files=[]}

{foreach from=$existing_pairs item=pair}
    {$existing_files[$pair.pair_id|intval] = []}

    {if $pair.image_id}
        {$existing_files[$pair.pair_id|intval]['icon'] = $pair.icon|fn_image_to_display:$thumbnail_width:$thumbnail_height}
    {/if}

    {if $pair.detailed_id}
        {$existing_files[$pair.pair_id|intval]['detailed'] = $pair.detailed|fn_image_to_display:$thumbnail_width:$thumbnail_height}
    {/if}
{/foreach}

<div class="file-uploader cm-file-uploader"
    data-ca-upload-url="{"image.upload"|fn_url}"
    data-ca-thumbnail-width="{$thumbnail_width}"
    data-ca-thumbnail-height="{$thumbnail_height}"
    data-ca-existing-pairs="{$existing_pairs|default:[]|array_values|json_encode}"
    data-ca-existing-pair-thumbnails="{$existing_files|json_encode}"
    data-ca-template-id="{$template_id}"
    data-ca-max-files-count="100"
    data-ca-new-files-param-name="{$file_name}"
    data-ca-default-image-pair-type="A"
    data-ca-max-file-size="{[$upload_max_filesize, $post_max_size]|min}"

    data-ca-image-pair-types="{$image_pair_types|default:[]|array_filter|json_encode}"
    data-ca-allow-sorting="{$allow_update_files}"
    data-ca-destroy-after-initializing="{!$allow_update_files}"
    data-ca-allow-thumbnail-upload="true"
    data-ca-image-pair-object-id="{$object_id}">

    <div class="file-uploader__files-container clearfix" data-ca-fileuploader-files-container>

    {if $allow_update_files}
        <div class="file-uploader__pickers">
            <div class="file-uploader__file-square {if !$existing_files}file-uploader__file-square--no-files{/if}">
                <div class="file-uploader__pickers-content">
                    <p><i class="file-uploader__pickers-icon icon icon-picture"></i></p>
                    <p class="file-uploader__pickers-text">
                        {__("drop_images_to_upload")}
                        <span class="file-uploader__pickers-text file-uploader__pickers-text--small">{__("or")}</span>
                    </p>
                    <div class="btn-group file-uploader__pickers-buttons" id="last_edited_items">
                        <a class="btn file-uploader__pickers-buttons-select" data-ca-fileupload-picker-local>
                            {if $existing_files}
                                {$upload_file_text|default:__("drop_images_select_short")}
                            {else}
                                {$upload_file_text|default:__("drop_images_select")}
                            {/if}
                        </a>
                        <a class="btn file-uploader__pickers-buttons-select dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            {if $breadcrumbs|sizeof >= 1}
                                {if !($hide_server || "RESTRICTED_ADMIN"|defined)}
                                    <li><a data-ca-fileupload-picker-server>{__("add_image_from_server")}</a></li>
                                {/if}
                                <li><a data-ca-fileupload-picker-url>{__("add_image_from_url")}</a></li>
                                {if $existing_files}
                                    <li class="divider"></li>
                                    <li><a data-ca-fileupload-remove-all>{__("delete_all_images")}</a></li>
                                {/if}
                            {/if}
                        </ul>
                    <!--last_edited_items--></div>
                </div>
            </div>
        </div>
    {/if}

    </div>
</div>

<div id="{$template_id}" style="display: none;">
    <div class="file-uploader__file">
        <div class="file-uploader__file-square">
            <div class="file-uploader__file-progressbar">
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100"
                    aria-valuenow="0">
                    <div class="bar" style="width: 0;" data-dz-uploadprogress></div>
                </div>
            </div>
            <div class="file-uploader__file-section file-uploader__file-section_text-data" data-dz-errormessage></div>
            <div class="file-uploader__file-section file-uploader__file-section_image">
                <img class="file-uploader__file-preview-image" data-dz-thumbnail/>
            </div>

            <div class="file-uploader__file-section file-uploader__file-section_under-image">
                <textarea 
                    class="cm-file-uploader-dynamic-field file-uploader__file-description-input"
                    data-ca-alt-text-detailed   
                    placeholder="{__("alternative_text")}"></textarea>

                <div class="file-uploader__file-control-menu file-uploader__file-control-menu--expanded">
                    <div class="file-uploader__file-control-menu-buttons-wrapper">
                        <a href="" target="_blank" class="cm-tooltip file-uploader__file-button file-uploader__file-button-preview" data-ca-preview-detailed
                            title="{__("preview")}"><i class="icon icon-eye-open"></i></a>
                        {if $allow_update_files}
                            <a class="cm-tooltip file-uploader__file-button file-uploader__file-button-delete"
                                data-ca-dz-remove title="{__("remove")}">
                                <i class="icon icon-trash"></i>
                            </a>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="cm-hide-with-inputs">
                <div class="file-uploader__remove-overlay hidden">
                    <div class="file-uploader__remove-text">{__("image_has_been_deleted")}</div>
                    <div>
                        {include file="buttons/button.tpl" but_onclick="javascript:void(0)" but_meta="file-uploader__remove-button-recover" but_text=__("recover")}
                    </div>
                </div>
                <input type="hidden" name="product_data[removed_image_pair_ids][]" value="" data-ca-image-remove>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-image-type>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-image-object-id>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-image-pair-id>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-image-position>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-upload-type>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-upload-file>
                <input type="hidden" name="" value="" class="cm-file-uploader-dynamic-field" data-ca-is-new-file>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    Tygh.lang.url = '{__("url")|escape:javascript}';
    Tygh.lang.cannot_upload_file = '{__("cannot_upload_file")|escape:javascript}';
</script>

