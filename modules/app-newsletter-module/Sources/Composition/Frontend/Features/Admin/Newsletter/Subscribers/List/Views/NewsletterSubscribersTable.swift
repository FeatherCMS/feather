import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTable: Component {
    let model: AdminNewsletterSubscribersListModel
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: NewsletterAdminRoutes.subscribers.description
                        )
                    ]
                )
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
