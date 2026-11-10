import FeatherWebShared
import FeatherWebAdmin
import HTML
import MediaWebAdmin
import NewsModule
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension NewsModule.Article.Form {
    struct Page: Component {
        let input: Input
        let dateFormatter: AdminDateFormatter
        let selectedImageAsset: AdminMediaAsset?
        let categories: [CategoryOption]
        let error: String?
        let title: String
        let action: String
        let submitLabel: String
        let moreActions: [AdminButton.State]
        let routes: NewsModule.Article.Router.Routes
        var metadataHref: String? = nil

        func html(
            context: inout BuilderContext
        ) -> Form {
            context.build(
                AdminForm(
                    action: action,
                    hiddenFields: metadataHiddenFields()
                ) {
                    context.build(
                        AdminBreadcrumb(
                            links: routes.breadcrumb
                        )
                    )
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: title,
                                description: "Create or update a news article.",
                                moreActions: moreActions
                            )
                        )
                    )
                    if let error {
                        P(error).class("admin-form__error")
                    }
                    context.build(AdminTabBar(links: tabLinks()))
                    context.build(
                        AdminRelationshipGroup(
                            pageHeader: .secondary(
                                title: "Article details",
                                description:
                                    "Edit the article content, image and categories."
                            )
                        ) {
                            context.build(
                                AdminFormFieldMediaPicker(
                                    state: .init(
                                        field: .init(
                                            key: "imageAssetId",
                                            label: "Featured image",
                                            value: input.imageAssetId,
                                            error: nil,
                                            isRequired: false
                                        ),
                                        selectedAsset: selectedImageAsset,
                                        browsePath: routes.imagePickerPath(
                                            "imageAssetId"
                                        ),
                                        defaultFolderPath: "news/articles",
                                        allowedExtensions: .images,
                                        previewStyle: .wide
                                    )
                                )
                            )
                            context.build(
                                AdminFormFieldInput(
                                    state: .init(
                                        name: "title",
                                        label: "Title",
                                        value: input.title,
                                        isRequired: true
                                    )
                                )
                                .setAsRemoveConfirmationLabel()
                            )
                            context.build(
                                AdminFormFieldTextArea(
                                    state: .init(
                                        name: "excerpt",
                                        label: "Excerpt",
                                        value: input.excerpt,
                                        style: .small,
                                        isRequired: true
                                    )
                                )
                            )
                            context.build(
                                AdminFormFieldRichContentEditor(
                                    state: .init(
                                        key: "content",
                                        label: "Content",
                                        value: input.content,
                                        error: nil,
                                        mediaFolderPath: "news/articles"
                                    )
                                )
                            )
                            context.build(
                                AdminFormFieldSelectAutocomplete(
                                    state: .init(
                                        name: "categoryIds[]",
                                        label: "Categories",
                                        placeholder: "Search and select categories...",
                                        options: categories.map {
                                            .init(
                                                label: $0.label,
                                                value: $0.value,
                                                isSelected: (input.categoryIds ?? [])
                                                    .contains($0.value)
                                            )
                                        },
                                        selectionMode: .multiple
                                    )
                                )
                            )
                            Div {
                                context.build(
                                    AdminSubmitButton(submitLabel, style: .primary)
                                )
                            }
                            .class("admin-form__actions")
                        }
                    )
                }
            )
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

        private func metadataHiddenFields() -> [AdminFormFieldHiddenValue] {
            let metadata = input.metadata
            return [
                .init(name: "slug", value: metadata.slug),
                .init(name: "status", value: metadata.status),
                .init(name: "publicationDate", value: metadata.publicationDate),
                .init(name: "expirationDate", value: metadata.expirationDate),
                .init(name: "metaTitle", value: metadata.metaTitle),
                .init(name: "metaExcerpt", value: metadata.metaExcerpt),
                .init(name: "imageURL", value: metadata.imageURL),
                .init(name: "canonicalURL", value: metadata.canonicalURL),
                .init(name: "noIndex", value: String(metadata.noIndex ?? false)),
                .init(name: "primaryKeyword", value: metadata.primaryKeyword),
                .init(name: "cssCodeInjection", value: metadata.cssCodeInjection),
                .init(name: "javascriptCodeInjection", value: metadata.javascriptCodeInjection),
                .init(name: "structuredDataCodeInjection", value: metadata.structuredDataCodeInjection),
            ]
        }
    }
}
