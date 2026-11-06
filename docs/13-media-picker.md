# Media picker integration

The Media module owns asset browsing and upload. A consuming module owns what an asset means to its feature: a single form value, a relation to another entity, ordering, removal, and display of connected assets.

## Current components

- `feather-core/Sources/Composition/WebAdmin/DesignSystem/HTML/Forms/AdminFormFieldMediaPicker.swift` provides the standard single-asset form field.
- `modules/cms-media-module/Sources/Composition/WebAdmin/Routes/Asset/Picker/` contains the reusable Admin picker, popup configuration, selection output, and selection bridge.
- `modules/cms-media-module/Sources/Composition/WebAdmin/Routes/Asset/Add/` contains the Media module's upload route.

## Configure a picker

`Asset.Picker.Popup.Configuration` controls the field name, selection mode, allowed extensions, default folder, preview variant, and route values. The default selection mode is `.single`.

The picker dispatches `admin-media-picker-selection` with the configured field and selected assets. Use `Asset.Picker.SelectionBridge` to connect that event to a consumer:

- `.singleInput(id:)` writes the first selected asset ID to an existing input.
- `.multipleInputs(containerID:name:)` replaces hidden inputs with the selected asset IDs.
- `.callback(functionName:)` passes the selected asset values to a JavaScript callback.

The bridge can submit a form after it writes the selection when `submitFormID` is provided.

## Choose the right integration

- For one asset ID stored directly on a form, use `AdminFormFieldMediaPicker` or a single-selection picker bridge.
- For a feature that stores asset relationships, use multiple selection and submit the IDs to that feature's own API. The feature owns its relationship records and connected-assets list.
- Uploading creates Media assets; associating them with a feature is a separate operation.
- Keep file storage, variant generation, and generic picker behavior in the Media module. Do not add feature-specific association behavior to the picker or uploader.

Follow the current route and namespace structure in the owning module. Do not copy older `Abstraction/Implementation` directory examples into new features.
