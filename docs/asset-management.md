# Media asset management plan

## Goal

Provide one generic media workflow that supports two different consumers:

1. Assigning one asset value to a form field.
2. Selecting or uploading assets and creating relationships that are displayed in a connected-assets list.

The media picker and uploader should remain generic. Domain features such as showcase galleries should own association creation, ordering, removal, and list presentation.

## Existing components

### Feather core

- `feather/feather-core/Sources/Composition/Frontend/Admin/DesignSystem/HTML/Forms/NewAdminFormFieldMediaPicker.swift`
  - Form-field integration.
  - Displays one current asset.
  - Writes one asset ID, original URL, or relative URL into a hidden input.
  - Provides Choose asset, Upload, and Clear actions.
  - Must remain single-selection and single-upload only.

- `feather/feather-core/Sources/Composition/Frontend/Admin/DesignSystem/HTML/Layouts/NewAdminDialogHost.swift`
  - Generic dialog loading and mounting.
  - Adds authentication-preserving same-origin requests and dialog presentation.
  - Must not contain media-specific selection or upload behavior.

### Media module

- `MediaAssetPickerView.swift`
  - Browses folders and assets in grid or list mode.
  - Already contains most of the multiple-selection behavior.
  - Should become the reusable selection surface for both single and multiple selection.

- `MediaAssetPickerDialogView.swift`
  - Wraps the picker in a large admin dialog.
  - Should remain a presentation wrapper.

- `MediaAssetUploadView.swift`
  - Handles normal uploads and picker uploads.
  - Already supports multiple files in the current working implementation.
  - Should expose the same result contract as the picker.
  - Should have single upload & multi-upload mode. 

- `AdminListMediaAssetModel.swift`
  - Contains list-specific picker state.
  - It consumes the shared `MediaAssetSelectionMode` and
    `MediaAssetPopupConfiguration` types from the media frontend layer.

### Current feature-specific implementation

- `ava/modules/app-avalliance-module/Sources/Composition/Frontend/Avalliance/Showcase/Edit/Galleries/List/Views/ShowcaseGalleryAssetActions.swift`
  - Composes the generic picker and uploader controls.
  - Uses the selection bridge to create hidden `assetIds` fields.
  - Submits the gallery association form.
  - Owns gallery association intent while the media module remains generic.

## Generic media API

The media frontend provides this public configuration:

```swift
public enum MediaAssetSelectionMode: String, Sendable {
    case single
    case multiple
}

public enum MediaAssetPopupAction: Sendable {
    case choose
    case upload
}

public struct MediaAssetPopupConfiguration: Sendable {
    public let field: String
    public let selectionMode: MediaAssetSelectionMode
    public let allowedExtensions: AllowedExtensions
    public let defaultFolderPath: String?
    public let previewVariant: String?
}
```

Expose reusable controls from `MediaFrontend`:

- `AdminMediaAssetPickerButton`
  - Opens the asset browser.
  - Supports single or multiple selection.

- `AdminMediaAssetUploadButton`
  - Opens the upload dialog.
  - Supports one or multiple files.

- `AdminMediaAssetSelectionBridge`
  - Receives the shared selection event.
  - Can write one hidden field, write repeated hidden fields, invoke a callback, or submit a form.
  - Does not know anything about showcases, members, services, or other domain entities.

The controls should centrally generate the query parameters for:

- picker mode;
- field key;
- `selection=single|multiple`;
- allowed extensions;
- default folder path;
- preview variant;
- upload versus browse route.

`presentation=dialog` should continue to be added by the dialog host/request flow rather than being embedded in domain components.

## Shared result contract

Both the picker and uploader should publish one canonical browser event:

```js
new-admin-media-picker-selection
```

with this payload:

```js
{
  field: "target-field",
  assets: [
    {
      id,
      url,
      previewURL,
      name,
      extension,
      title,
      altText,
      status
    }
  ]
}
```

Single selection publishes an array containing one asset. Multiple selection publishes all selected or uploaded assets. This removes the current split between direct single-picker handling, multiple-picker session storage, and upload-specific event construction.

The event is a browser integration contract, not a domain API. Domain screens decide what to do with the selected asset IDs.

## Consumer A: form value assignment

`NewAdminFormFieldMediaPicker` should remain the standard form-field component.

Expected behavior:

- one selected asset;
- one uploaded asset;
- one hidden form value;
- preview and clear behavior;
- output modes of asset ID, original URL, or relative URL;
- no asset arrays;
- no relationship creation;
- no gallery-specific submission logic;
- no session-storage selection state.

Its single picker and uploader dialogs can use the shared media routes and result contract, but the field component remains responsible for applying the one returned asset to its own input.

This continues to support existing users in Web, Account, Avalliance, News, and rich content forms without changing their semantics.

## Consumer B: relationship management

Relationship screens need a separate composition pattern:

```text
Relationship screen
├── Choose assets button
├── Upload assets button
├── connected assets list/grid
├── per-item edit/remove actions
└── bulk selection and bulk removal
```

The relationship screen should use:

- `AdminMediaAssetPickerButton(selectionMode: .multiple)`;
- `AdminMediaAssetUploadButton(selectionMode: .multiple)`;
- `AdminMediaAssetSelectionBridge` configured for repeated IDs;
- a domain-specific association endpoint;
- a domain-specific connected-assets list.

The media dialogs return asset references only. The relationship feature then submits those IDs to its own endpoint, for example:

```text
POST /admin/avalliance/showcases/{showcaseID}/gallery/add/
assetIds=<id>&assetIds=<id>
```

The association endpoint is responsible for:

- validating the parent entity;
- validating all asset IDs;
- rejecting duplicates or treating the operation as idempotent;
- preserving or assigning ordering;
- creating the relationship records;
- returning the updated relationship list or redirecting back to it.

Uploading into a relationship screen should use the relationship's configured target folder. Uploading and associating remain two separate concerns: the uploader creates media assets, and the relationship endpoint associates their returned IDs.

The connected-assets list should use the standard admin list/table components and support:

- asset preview and filename;
- ordering where the relationship supports it;
- direct asset preview links;
- single remove confirmation in a dialog;
- multi-select bulk removal in a dialog;
- empty state and pagination if required by the relationship size.

The same pattern can then be reused for showcase galleries, member galleries, service media, partner media, and future asset relationships without adding domain behavior to the media picker.

## Implementation sequence and extension points

1. Add shared media configuration, selection mode, asset result, URL builder, and event payload types in `MediaFrontend`.
2. Refactor `MediaAssetPickerView` and `MediaAssetUploadView` to consume that configuration.
3. Make both single and multiple picker/upload flows publish the same result event.
4. Add reusable picker and uploader popup controls.
5. Keep `NewAdminFormFieldMediaPicker` single-item only and migrate its internal buttons to the shared route contract where practical.
6. Add the reusable selection bridge for one hidden value versus repeated relationship IDs.
7. Replace the custom gallery picker JavaScript in `ShowcaseGalleryAssetActions` with the generic controls and bridge.
8. Keep showcase gallery association, connected-list rendering, ordering, remove, and bulk-remove logic in the Avalliance feature.
9. Audit every current media picker caller and classify it explicitly as either:
   - form value assignment; or
   - relationship management.
10. Remove obsolete multiple-selection code from Feather core and avoid adding media-specific behavior to `NewAdminDialogHost` or `NewAdminFormFieldMediaPicker`.

## Acceptance matrix

| Flow | Control | Selection | Result | Consumer action |
|---|---|---:|---|---|
| Image form field | Form field picker | One | One asset ID/URL | Set hidden form value |
| Image form field upload | Form field uploader | One | One uploaded asset | Set hidden form value |
| Relationship choose | Picker popup | One or many | Asset array | Create associations |
| Relationship upload | Upload popup | One or many | Uploaded asset array | Create associations |
| Relationship list | Domain list | Existing associations | Connected asset rows/cards | Preview, reorder, remove |

## Validation

The implementation should be verified with:

- single form picker selection;
- single form upload;
- multiple picker selection across folders and pagination;
- multiple upload with partial failure handling;
- association creation from selected assets;
- association creation from uploaded assets;
- duplicate association handling;
- connected-list refresh after association;
- single and bulk removal dialogs;
- correct target folder for relationship uploads;
- existing Web, Account, Avalliance, News, and rich-content form users.

The implementation now follows this plan: form fields remain single-asset consumers, while relationship screens use the reusable multi-asset popup controls and selection bridge.

## Use cases

### 1. Assign one asset to a form value

Use `NewAdminFormFieldMediaPicker` when the domain model has one asset value,
such as `profileImageID`, `logoAssetID`, `heroImageID`, or `videoAssetID`.

The field owns the value that will be submitted. The media module only returns
the selected asset metadata; it does not know which domain property receives
the ID.

```text
┌──────────────────────┐
│ Admin form            │
│                      │
│ [Choose asset]        │
│ [Upload]              │
│ [asset preview]       │
│ hidden: imageAssetID  │
└──────────┬───────────┘
           │ open single-selection dialog
           ▼
┌──────────────────────────────┐
│ Media asset dialog            │
│                              │
│ browse one asset              │
│ or upload one asset           │
└──────────┬───────────────────┘
           │ assets: [asset]
           ▼
┌──────────────────────┐
│ Form field adapter    │
│ input.value = asset.id│
└──────────┬───────────┘
           │ submit form
           ▼
┌──────────────────────┐
│ Domain form endpoint  │
└──────────────────────┘
```

Rules:

- selection is always single;
- upload is always single;
- the field stores one ID or configured URL output;
- replacing an asset replaces the field value;
- clearing an asset clears the field value;
- no relationship or association endpoint is involved.

### 2. Select assets for a relationship

Use the popup controls when the selected assets belong to another entity via a
relationship or join table. A showcase gallery is the reference example.

```text
┌──────────────────────────────────┐
│ Showcase gallery                  │
│                                  │
│ [Choose assets] [Upload assets]  │
│                                  │
│ connected asset list              │
└───────────────┬──────────────────┘
                │ choose assets
                ▼
┌──────────────────────────────────┐
│ Media picker dialog               │
│                                  │
│ select A                         │
│ select B                         │
│ select C                         │
│                                  │
│ [Use assets]                     │  fixed footer
└───────────────┬──────────────────┘
                │ assets: [A, B, C]
                ▼
┌──────────────────────────────────┐
│ Selection bridge                 │
│ hidden assetIds: A, B, C         │
└───────────────┬──────────────────┘
                │ submit association form
                ▼
┌──────────────────────────────────┐
│ Showcase gallery endpoint         │
│ validate showcase and asset IDs   │
│ create relationship rows          │
└───────────────┬──────────────────┘
                │ redirect or updated response
                ▼
┌──────────────────────────────────┐
│ Connected asset list              │
└──────────────────────────────────┘
```

The picker does not create the relationship. The domain feature receives the
asset IDs and decides how to associate them, including ordering and duplicate
handling.

### 3. Upload assets for a relationship

The upload flow has the same result contract as the picker, but the asset
records are created before the relationship is submitted.

```text
┌──────────────────────────────┐
│ Relationship screen           │
│ [Upload assets]               │
└──────────────┬───────────────┘
               │ default folder supplied by consumer
               ▼
┌──────────────────────────────┐
│ Upload dialog                 │
│ choose one or more files      │
│ upload progress and errors    │
└──────────────┬───────────────┘
               │ upload each file
               ▼
┌──────────────────────────────┐
│ Media asset service           │
│ create assets in target folder│
└──────────────┬───────────────┘
               │ assets: [A, B, C]
               ▼
┌──────────────────────────────┐
│ Selection bridge              │
│ write repeated asset IDs      │
└──────────────┬───────────────┘
               │ submit association
               ▼
┌──────────────────────────────┐
│ Domain relationship endpoint  │
└──────────────────────────────┘
```

Uploading and associating are intentionally separate operations:

- the media module owns file validation, storage, variants, and asset creation;
- the domain module owns relationship validation and association creation;
- a failed association must not be mistaken for a failed upload;
- retrying association should be idempotent or reject duplicates explicitly.

### 4. Single-selection popup outside a standard form field

Some screens may need a custom single-asset interaction rather than the full
form field card. They can use:

```swift
AdminMediaAssetPickerButton(
    "Choose cover",
    configuration: .init(
        field: "cover-asset",
        selectionMode: .single,
        allowedExtensions: .images,
        previewVariant: "cover"
    )
)

AdminMediaAssetSelectionBridge(
    field: "cover-asset",
    output: .singleInput(id: "coverAssetID")
)
```

This is still value assignment, not relationship management. The consumer
receives one asset ID and decides when to submit its form.

### 5. Connected asset list management

After associations exist, the domain feature renders its own connected list.
The list should not be implemented inside the media picker because the list
belongs to the parent entity and its relationship semantics.

```text
┌──────────────────────────────┐
│ Domain relationship list      │
├──────────────────────────────┤
│ [ ] preview  filename         │
│ [ ] preview  filename         │
│ [ ] preview  filename         │
├──────────────────────────────┤
│ [Remove selected]             │
└──────────────┬───────────────┘
               │ single or bulk remove
               ▼
┌──────────────────────────────┐
│ Domain remove confirmation    │
│ dialog                        │
└──────────────┬───────────────┘
               │ relationship IDs
               ▼
┌──────────────────────────────┐
│ Domain relationship endpoint  │
└──────────────────────────────┘
```

The connected list may add domain-specific behavior such as ordering, cover
designation, captions, or role labels. Those concerns remain outside the
generic media controls.

## Component responsibility diagram

```text
┌───────────────────────────────────────────────────────────┐
│ Feather core                                               │
│                                                           │
│ NewAdminFormFieldMediaPicker                              │
│ - one value                                                │
│ - one preview                                               │
│ - single choose/upload                                      │
│                                                           │
│ NewAdminDialogHost                                         │
│ - fetch and mount dialogs                                  │
│ - no media-specific behavior                              │
└───────────────────────────────┬───────────────────────────┘
                                │ dialog request
                                ▼
┌───────────────────────────────────────────────────────────┐
│ MediaFrontend                                              │
│                                                           │
│ MediaAssetPopupConfiguration                              │
│ AdminMediaAssetPickerButton                               │
│ AdminMediaAssetUploadButton                               │
│ AdminMediaAssetSelectionBridge                            │
│ MediaAssetPickerView                                      │
│ MediaAssetUploadView                                      │
│                                                           │
│ returns asset metadata, never domain relationships         │
└───────────────────────────────┬───────────────────────────┘
                                │ selection event
                                ▼
┌───────────────────────────────────────────────────────────┐
│ Domain frontend module                                     │
│                                                           │
│ form value adapter OR relationship adapter                 │
│ - hidden form value                                        │
│ - repeated relationship IDs                                │
│ - association endpoint                                     │
│ - connected asset list                                     │
└───────────────────────────────────────────────────────────┘
```

## Selection event lifecycle

Both choosing and uploading publish the same browser event. The difference is
only how the assets are obtained.

```text
choose flow:  picker dialog ────────┐
                                    ├─> assets[]
upload flow:  upload dialog ────────┘
                                      │
                                      ▼
                         new-admin-media-picker-selection
                                      │
              ┌───────────────────────┴──────────────────────┐
              │                                              │
              ▼                                              ▼
       singleInput(id:)                              multipleInputs(...)
       input.value = asset.id                         hidden input per asset
              │                                              │
              ▼                                              ▼
       form value endpoint                         relationship endpoint
```

## Decision guide

```text
Does the screen store one asset value directly?
        │
       yes ──> NewAdminFormFieldMediaPicker
        │
       no
        ▼
Does the screen create rows connecting assets to a parent entity?
        │
       yes ──> popup control + selection bridge + domain endpoint + list
        │
       no ──> introduce a consumer-specific adapter without changing
               the generic media picker
```

Use these rules when adding a new feature:

- one domain column holding one asset ID: use the form field picker;
- one custom single-asset interaction: use the picker button with
  `singleInput`;
- a join table or relationship collection: use multiple popup controls and a
  domain association endpoint;
- connected rows/cards: render them in the domain feature;
- file storage and generated variants: leave them in the media module;
- parent-specific behavior: never add it to `MediaAssetPickerView` or
  `MediaAssetUploadView`.

## Example relationship implementation shape

```text
Feature/Parent/Edit/Media/
├── Add/
│   ├── Abstraction/
│   ├── Implementation/
│   └── Views/
│       └── ParentMediaActions.swift
├── List/
│   ├── Abstraction/
│   ├── Implementation/
│   └── Views/
│       ├── ParentMediaTable.swift
│       └── ParentMediaRow.swift
└── Remove/
    ├── Abstraction/
    ├── Implementation/
    └── Views/
        └── ParentMediaConfirmation.swift
```

`ParentMediaActions` composes the generic media controls. The add/association
interactor and repository call the parent-specific API. The list and remove
features operate on relationship IDs, not raw media-picker state.
