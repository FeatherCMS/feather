import BlogAdminAPI
import BlogAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogTagForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var title: FieldState
        var excerpt: FieldState
        var content: FieldState
        var imageAssetId: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var metadata: AdminMetadataFields.State
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
        }
    }

    var state: State
    var metadataHref: String? = nil
    var action: String
    var submitLabel: String
    var publishLabel: String? = nil
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    private func metadataTabLinks() -> [AdminPillTabs.Link] {
        var links: [AdminPillTabs.Link] = [
            .init(
                label: "Details",
                href: action,
                isCurrent: true
            )
        ]
        if let metadataHref {
            links.append(
                .init(label: "Metadata", href: metadataHref, isCurrent: false)
            )
        }
        return links
    }

    func html(context: inout RenderContext) -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            context.render(AdminPillTabs(links: metadataTabLinks()))

            Div {

                context.render(
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
                )
                context.render(
                    FormInputField(
                        name: state.title.key,
                        label: state.title.label,
                        value: state.title.value,
                        error: state.title.error,
                        isRequired: true
                    )
                )
                context.render(
                    textarea(
                        state.excerpt,
                        required: true,
                        rows: 4,
                        context: &context
                    )
                )
                context.render(
                    textarea(state.content, required: true, context: &context)
                )
            }
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
                        context.render(
                            AdminNavigationButton(
                                removeLabel,
                                href: removeHref,
                                classes: ["danger"]
                            )
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
        rows: Int = 12,
        context: inout RenderContext
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
