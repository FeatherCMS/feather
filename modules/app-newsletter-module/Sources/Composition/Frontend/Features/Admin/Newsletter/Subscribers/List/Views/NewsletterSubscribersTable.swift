import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTable: Component {
    let model: AdminNewsletterSubscribersListModel
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: NewsletterAdminRoutes.subscribers.description
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
                    permissions: permissions
                )
            )
        }
        .class("cms-section")
    }
}
