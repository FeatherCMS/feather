import NewsApplication
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsModule
import SGML
import WebBuilders
import WebComponents

extension NewsModule.Category.Detail {
    struct Page: Component {
        let item: Category.Detail.Model
        let permissions: AdminListActions
        let routes: NewsModule.Category.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb,
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

        private var actions: [AdminDetailView.Action] {
            var result: [AdminDetailView.Action] = []
            if permissions.allows(NewsModule.Category.Permissions.update) {
                result.append(
                    .init(
                        label: "Edit",
                        href: routes.editPath(item.id),
                        style: .primary
                    )
                )
            }
            if permissions.allows(NewsModule.Category.Permissions.delete) {
                result.append(
                    .init(
                        label: "Remove",
                        href: routes.removePath(item.id),
                        style: .destructive
                    )
                )
            }
            return result
        }
    }
}
