import FeatherAdmin
import HTML
import Hummingbird
import NewsAdminAPI
import NewsContracts
import SGML
import WebBuilders
import WebComponents

struct AdminNewsCategoryDetailsPage: Component {
    let item: Components.Schemas.NewsCategoryDetailSchema
    let permissions: NewAdminListActions

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        context.build(
            NewAdminDetailView(
                breadcrumb: NewsAdminRoutes.categoriesBreadcrumb,
                pageHeader: .primary(
                    title: item.title,
                    description: "News category details."
                ),
                fields: [
                    .init(label: "Title", value: item.title),
                    .init(label: "Excerpt", value: item.excerpt),
                    .init(label: "Content", value: item.content),
                    .init(label: "Slug", value: item.metadata.slug),
                    .init(label: "Status", value: item.metadata.status),
                ],
                actions: actions
            )
        )
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(NewsPermissions.Categories.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        NewsAdminRoutes.categoryEdit(RouterPath(item.id))
                        .description + "/",
                    style: .primary
                )
            )
        }
        if permissions.allows(NewsPermissions.Categories.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href:
                        NewsAdminRoutes.categoryRemove(RouterPath(item.id))
                        .description + "/",
                    style: .destructive
                )
            )
        }
        return result
    }
}
