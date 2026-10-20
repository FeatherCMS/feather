import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebPageForm: Component {

    struct FieldState: FeatherWebAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherWebAdmin.Object {
        var title: FieldState
        var excerpt: FieldState
        var content: FieldState
        var imageAssetId: FieldState
        var selectedImageAsset: AdminMediaAsset?
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
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    private func metadataTabLinks() -> [AdminTabBar.Link] {
        var links: [AdminTabBar.Link] = [
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

    func html(context: inout BuilderContext) -> Form {
        let form = AdminForm(action: action) {
            if let success = state.success {
                P(success).class("admin-form__success")
            }
            if let error = state.error {
                P(error).class("admin-form__error")
            }

            context.build(AdminTabBar(links: metadataTabLinks()))

            context.build(
                AdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: state.imageAssetId.key,
                            label: state.imageAssetId.label,
                            value: state.imageAssetId.value,
                            error: state.imageAssetId.error
                        ),
                        selectedAsset: state.selectedImageAsset.map {
                            .init(
                                id: $0.id,
                                name: $0.name,
                                slugPath: $0.slugPath,
                                url: $0.url,
                                extension: $0.extension,
                                contentType: $0.contentType,
                                sizeBytes: $0.sizeBytes,
                                variants: $0.variants,
                                title: $0.title,
                                altText: $0.altText,
                                status: $0.status
                            )
                        },
                        browsePath:
                            "/admin/media/assets/?picker=1&field=\(state.imageAssetId.key.queryEncoded())&extensions=\(AllowedExtensions.images.queryValue)",
                        defaultFolderPath: "web/pages",
                        allowedExtensions: .images,
                        previewStyle: .wide
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: state.title.key,
                        label: state.title.label,
                        value: state.title.value,
                        error: state.title.error,
                        isRequired: true
                    )
                )
            )
            context.build(textarea(state.excerpt, rows: 4))
            context.build(
                AdminFormFieldRichContentEditor(
                    state: .init(
                        key: state.content.key,
                        label: state.content.label,
                        value: state.content.value,
                        error: state.content.error,
                        mediaFolderPath: "web/pages"
                    )
                )
            )
            Div {
                context.build(AdminSubmitButton(submitLabel))
                if let removeHref {
                    context.build(
                        AdminButton(
                            removeLabel,
                            href: removeHref,
                            style: .destructive
                        )
                    )
                }
            }
            .class("admin-form__actions")
        }
        return context.build(form)
    }

    private func textarea(
        _ field: FieldState,
        required: Bool = true,
        rows: Int = 12
    ) -> AdminFormFieldTextArea {
        AdminFormFieldTextArea(
            state: .init(
                name: field.key,
                label: field.label,
                value: field.value,
                error: field.error,
                style: rows <= 4 ? .small : .large,
                isRequired: required
            )
        )
    }

}
