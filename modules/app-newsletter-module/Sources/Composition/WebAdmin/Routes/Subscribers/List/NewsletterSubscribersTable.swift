import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTable: Component {
    let model: Subscriber.List.Model
    let permissions: AdminListActions
    let routes: Subscriber.Router.Routes

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(
                    links: routes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: routes.list.path
                        )
                    ]
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Subscribers",
                        description: "Manage newsletter subscribers."
                    )
                )
            )
            context.build(
                NewsletterSubscribersTableContent(
                    model: model,
                    permissions: permissions,
                    routes: routes
                )
            )
        }
        .class("cms-section")
    }
}
