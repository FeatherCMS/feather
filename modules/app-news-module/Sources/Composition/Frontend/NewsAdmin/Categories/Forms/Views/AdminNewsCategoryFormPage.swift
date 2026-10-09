import FeatherAdmin
import HTML
import MediaFrontend
import WebBuilders
import WebComponents
import WebFrontend

struct AdminNewsCategoryFormPage: Component {
    let input: AdminNewsCategoryFormInput
    let selectedImageAsset: NewAdminMediaAsset?
    let error: String?
    let title: String
    let action: String
    let submitLabel: String
    let removeHref: String?

    func html(
        context: inout BuilderContext
    ) -> Form {
        context.build(
            NewAdminForm(action: action) {
                context.build(
                    NewAdminBreadcrumb(
                        links: NewsAdminRoutes.categoriesBreadcrumb
                    )
                )
                context.build(
                    NewAdminPageHeader(
                        state: .primary(
                            title: title,
                            description: "Create or update a news category."
                        )
                    )
                )
                if let error {
                    P(error).class("new-admin-form__error")
                }
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "title",
                            label: "Title",
                            value: input.title,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldTextArea(
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
                    NewAdminFormFieldTextArea(
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
                    NewAdminFormFieldMediaPicker(
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
                        NewAdminSubmitButton(submitLabel, style: .primary)
                    )
                    if let removeHref {
                        context.build(
                            NewAdminButton(
                                "Remove",
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        )
    }
}
