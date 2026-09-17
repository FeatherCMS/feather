# Media variant processing

Media processing is modeled with two configuration levels:

```text
media_variant
    └── media_variant_processor
            └── media_asset_variant (generated asset output)
```

`media_variant` is the stable logical output, for example `preview`. It owns
the public key, display name, required flag, and active flag.

`media_variant_processor` is a rule owned by one variant. It stores the rule
name, supported source extensions, command template, and active flag. It is
not a globally reusable processor entity. This keeps the model small while
allowing one logical variant to use different tools for different source
formats:

```text
preview -> jpg,png,bmp -> ImageMagick
preview -> pdf         -> Ghostscript
preview -> mp4,mov     -> FFmpeg
```

The generated `media_asset_variant` table stores the selected variant and
processor-rule IDs, the storage object, and the output extension. Public
URLs use the variant key rather than the processor name:

```text
/media/variants/{asset-id}/preview.webp
```

When an asset is uploaded, the worker selects active rules matching the
original extension, executes the selected command, and stores the result at:

```text
assets/{asset-id}/variants/{variant-key}.{extension}
```

Requiredness belongs to the logical variant. Editing a processor rule should
invalidate or regenerate outputs associated with that rule; generated rows
therefore retain the selected rule ID for traceability.

The admin interface lists variants. Editing a variant shows its child
processor rules and supports creating, editing, and removing those rules on
the same page.
