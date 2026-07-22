import CSS
import HTML
import SGML
import WebStandards

struct BlogAuthorForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var name: FieldState
        var excerpt: FieldState
        var content: FieldState
        var profileImageAssetId: FieldState
        var metadata: AdminMetadataFields.State
        var selectedProfileImage: AdminMediaAssetReferenceModel?
        var canSelectProfileImage: Bool
        var canUploadProfileImage: Bool
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            name.error = errors[name.key]
            excerpt.error = errors[excerpt.key]
            content.error = errors[content.key]
            profileImageAssetId.error = errors[profileImageAssetId.key]
            metadata.apply(errors: errors)
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
                        key: state.profileImageAssetId.key,
                        label: state.profileImageAssetId.label,
                        value: state.profileImageAssetId.value,
                        error: state.profileImageAssetId.error
                    ),
                    selectedAsset: state.selectedProfileImage,
                    browsePath:
                        "/admin/media/assets/?picker=1&field=\(state.profileImageAssetId.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                    allowedExtensions: ["png", "jpg", "jpeg", "webp"]
                )
            )
            FormInputField(
                name: state.name.key,
                label: state.name.label,
                value: state.name.value,
                error: state.name.error,
                isRequired: true
            )
            textarea(state.excerpt, required: true, rows: 4)
            textarea(state.content, required: true)
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
        required: Bool = false,
        rows: Int = 8
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
}
