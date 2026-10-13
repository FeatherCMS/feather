import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import NewsAdminAPI
import NewsContracts
import SGML
import WebBuilders
import WebComponents

struct AdminNewsArticleDetailsPage: Component {
    let item: Components.Schemas.NewsArticleDetailSchema
    let permissions: NewAdminListActions

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        context.build(
            NewAdminDetailView(
                breadcrumb: NewsAdminRoutes.articlesBreadcrumb,
                pageHeader: .primary(
                    title: item.title,
                    description: "News article details."
                ),
                fields: [
                    .init(label: "Title", value: item.title),
                    .init(label: "Excerpt", value: item.excerpt),
                    .init(label: "Content", value: item.content),
                    .init(
                        label: "Categories",
                        value: item.categoryIds.joined(separator: ", ")
                            .emptyToNil ?? "—"
                    ),
                    .init(label: "Slug", value: item.metadata.slug),
                    .init(label: "Status", value: item.metadata.status),
                ],
                actions: actions
            )
        )
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(NewsPermissions.Articles.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        NewsAdminRoutes.articleEdit(RouterPath(item.id))
                        .description + "/",
                    style: .primary
                )
            )
        }
        if permissions.allows(NewsPermissions.Articles.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href:
                        NewsAdminRoutes.articleRemove(RouterPath(item.id))
                        .description + "/",
                    style: .destructive
                )
            )
        }
        return result
    }
}
