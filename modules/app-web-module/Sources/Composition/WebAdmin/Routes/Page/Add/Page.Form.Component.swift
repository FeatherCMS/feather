import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Page.Form {
    struct Component: WebComponents.Component {

        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct State: Sendable {
            var title: FieldState
            var excerpt: FieldState
            var content: FieldState
            var imageAssetId: FieldState
            var selectedImageAsset: AdminMediaAsset?
            var metadata: WebModule.Metadata.Fields.State
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
        var mediaAssetList: WebRoute
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
                    .init(
                        label: "Metadata",
                        href: metadataHref,
                        isCurrent: false
                    )
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

                var browseComponents = URLComponents()
                browseComponents.path = mediaAssetList.path
                browseComponents.queryItems = [
                    URLQueryItem(name: "picker", value: "1"),
                    URLQueryItem(
                        name: "field",
                        value: state.imageAssetId.key
                    ),
                    URLQueryItem(
                        name: "extensions",
                        value: AllowedExtensions.images.queryValue
                    ),
                ]
                let imagePickerPath =
                    browseComponents.string ?? browseComponents.path

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
                            browsePath: imagePickerPath,
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
}
