import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsApplication
import NewsModule
import SGML
import WebBuilders
import WebComponents

extension NewsModule.Article.Detail {
    struct Page: Component {
        let item: Model
        let permissions: AdminListActions
        let routes: NewsModule.Article.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb,
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
                            value: item.categoryIDs.joined(separator: ", ")
                                .emptyToNil ?? "—"
                        ),
                        .init(label: "Slug", value: item.metadata.slug),
                        .init(label: "Status", value: item.metadata.status),
                    ],
                    actions: actions
                )
            )
        }

        private var actions: [AdminDetailView.Action] {
            var result: [AdminDetailView.Action] = []
            if permissions.allows(NewsModule.Article.Permissions.update) {
                result.append(
                    .init(
                        label: "Edit",
                        href: routes.editPath(item.id),
                        style: .primary
                    )
                )
            }
            if permissions.allows(NewsModule.Article.Permissions.delete) {
                result.append(
                    .init(
                        label: "Remove",
                        href: routes.removePath(item.id),
                        style: .destructive,
                        confirmationItem: item.title
                    )
                )
            }
            return result
        }
    }
}
