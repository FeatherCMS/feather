import FeatherWebAdmin
import HTML
import MediaWebAdmin
import WebBuilders
import WebComponents
import WebModuleWebAdmin

struct AdminNewsArticleFormPage: Component {
    let input: AdminNewsArticleFormInput
    let selectedImageAsset: AdminMediaAsset?
    let categories: [AdminNewsArticleCategoryOption]
    let error: String?
    let title: String
    let action: String
    let submitLabel: String
    let removeHref: String?

    func html(
        context: inout BuilderContext
    ) -> Form {
        context.build(
            AdminForm(action: action) {
                context.build(
                    AdminBreadcrumb(
                        links: NewsAdminRoutes.articlesBreadcrumb
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: title,
                            description: "Create or update a news article."
                        )
                    )
                )
                if let error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "title",
                            label: "Title",
                            value: input.title,
                            isRequired: true
                        )
                    )
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
                    AdminFormFieldTextArea(
                        state: .init(
                            name: "content",
                            label: "Content",
                            value: input.content,
                            style: .large,
                            isRequired: true
                        )
                    )
                )
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
                            browsePath:
                                "/admin/media/assets/?picker=1&field=imageAssetId&extensions=\(AllowedExtensions.images.queryValue)",
                            defaultFolderPath: "news/articles",
                            allowedExtensions: .images,
                            previewStyle: .wide
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
                context.build(
                    AdminMetadataFields(
                        state: input.metadata.fields,
                        showTitle: true
                    )
                )
                Div {
                    context.build(
                        AdminSubmitButton(submitLabel, style: .primary)
                    )
                    if let removeHref {
                        context.build(
                            AdminButton(
                                "Remove",
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("admin-form__actions")
            }
        )
    }
}
