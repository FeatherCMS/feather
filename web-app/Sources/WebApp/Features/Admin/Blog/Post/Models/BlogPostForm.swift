import HTML
import SGML
import WebStandards

struct BlogPostForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct OptionState: Object {
        var key: String
        var label: String
        var value: String
        var isSelected: Bool
    }

    struct State: Object {
        var title: FieldState
        var excerpt: FieldState
        var content: FieldState
        var imageAssetId: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var metadata: AdminMetadataFields.State
        var authorOptions: [OptionState]
        var tagOptions: [OptionState]
        var authorIdsError: String?
        var tagIdsError: String?
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            content.error = errors[content.key]
            imageAssetId.error = errors[imageAssetId.key]
            metadata.apply(errors: errors)
            authorIdsError = errors["authorIds"] ?? errors["authorIds[]"]
            tagIdsError = errors["tagIds"] ?? errors["tagIds[]"]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var publishLabel: String? = nil
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            AdminMediaAssetPicker(
                state: .init(
                    field: .init(
                        key: state.imageAssetId.key,
                        label: state.imageAssetId.label,
                        value: state.imageAssetId.value,
                        error: state.imageAssetId.error
                    ),
                    selectedAsset: state.selectedImageAsset,
                    browsePath:
                        "/admin/media/assets/?picker=1&field=\(state.imageAssetId.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                    allowedExtensions: ["png", "jpg", "jpeg", "webp"]
                )
            )
            FormInputField(
                name: state.title.key,
                label: state.title.label,
                value: state.title.value,
                error: state.title.error,
                isRequired: true
            )
            textarea(state.excerpt, rows: 4)
            textarea(state.content)
            multiselect(
                key: "authorIds[]",
                label: "Authors",
                placeholder: "Search and select authors...",
                options: state.authorOptions,
                error: state.authorIdsError
            )
            multiselect(
                key: "tagIds[]",
                label: "Tags",
                placeholder: "Search and select tags...",
                options: state.tagOptions,
                error: state.tagIdsError
            )
            AdminMetadataFields(
                state: state.metadata,
                showTitle: true,
                titleRequired: false
            )

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let publishLabel {
                        Button(publishLabel)
                            .type(.submit)
                            .name("submitAction")
                            .value("publish")
                            .class("secondary")
                    }
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        )
                    }
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }

    private func textarea(
        _ field: FieldState,
        required: Bool = true,
        rows: Int = 12
    ) -> FormTextAreaField {
        FormTextAreaField(
            name: field.key,
            label: field.label,
            value: field.value,
            error: field.error,
            rows: rows,
            isRequired: required
        )
    }

    private func multiselect(
        key: String,
        label: String,
        placeholder: String,
        options: [OptionState],
        error: String?
    ) -> some FlowContent {
        AdminAutocompleteField(
            state: .init(
                key: key,
                label: label,
                placeholder: placeholder,
                options: options.map {
                    .init(
                        label: $0.label,
                        value: $0.value,
                        isSelected: $0.isSelected
                    )
                },
                error: error,
                selectionMode: .multiple,
                isEnabled: true
            )
        )
    }
}
