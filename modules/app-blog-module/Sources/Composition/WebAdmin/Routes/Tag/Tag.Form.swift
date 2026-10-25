import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension BlogModule.Tag {
    struct Form: Component {
        struct FieldState: Codable, Sendable, Equatable, Hashable {
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

            mutating func apply(errors: [String: String]) {
                title.error = errors[title.key]
                excerpt.error = errors[excerpt.key]
                content.error = errors[content.key]
                imageAssetId.error = errors[imageAssetId.key]
                metadata.apply(errors: errors)
            }
        }
        var state: State
        var browsePath: String
        var metadataHref: String?
        var action: String
        var submitLabel: String
        var removeHref: String?
        var removeLabel: String = "Remove"

        func html(context: inout BuilderContext) -> HTML.Form {
            let form = AdminForm(action: action) {
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(AdminTabBar(links: tabLinks()))
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
                            browsePath: browsePath,
                            defaultFolderPath: "blog/tags",
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
                context.build(
                    AdminFormFieldTextArea(
                        state: .init(
                            name: state.excerpt.key,
                            label: state.excerpt.label,
                            value: state.excerpt.value,
                            error: state.excerpt.error,
                            style: .small,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldTextArea(
                        state: .init(
                            name: state.content.key,
                            label: state.content.label,
                            value: state.content.value,
                            error: state.content.error,
                            style: .large,
                            isRequired: true
                        )
                    )
                )
                Div {
                    context.build(
                        AdminSubmitButton(submitLabel, style: .primary)
                    )
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

        private func tabLinks() -> [AdminTabBar.Link] {
            var links = [
                AdminTabBar.Link(
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
    }
}
