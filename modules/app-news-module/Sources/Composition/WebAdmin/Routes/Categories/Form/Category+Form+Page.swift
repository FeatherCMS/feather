import FeatherWebAdmin
import HTML
import MediaWebAdmin
import NewsModule
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension NewsModule.Category.Form {
    struct Page: Component {
        let input: Input
        let selectedImageAsset: AdminMediaAsset?
        let error: String?
        let title: String
        let action: String
        let submitLabel: String
        let removeHref: String?
        let routes: NewsModule.Category.Router.Routes

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
                                description: "Create or update a news category."
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
                                defaultFolderPath: "news/categories",
                                allowedExtensions: .images,
                                previewStyle: .wide
                            )
                        )
                    )
                    context.build(
                        AdminMetadataFields(
                            state: input.metadata.adminFields(
                                template: "news.category"
                            ),
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
}
