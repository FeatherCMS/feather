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
        let selectedImageAsset: AdminMediaAsset?
        let categories: [CategoryOption]
        let error: String?
        let title: String
        let action: String
        let submitLabel: String
        let moreActions: [AdminButton.State]
        let routes: NewsModule.Article.Router.Routes

        func html(
            context: inout BuilderContext
        ) -> Form {
            context.build(
                AdminForm(action: action) {
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
                        WebModule.Metadata.Fields(
                            state: input.metadata.fields,
                            showTitle: true,
                            mediaAssetList: routes.mediaAssetList
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
    }
}
