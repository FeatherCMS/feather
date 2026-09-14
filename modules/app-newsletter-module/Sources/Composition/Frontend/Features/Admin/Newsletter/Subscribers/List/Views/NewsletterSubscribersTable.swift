import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTable: Component {
    let model: AdminNewsletterSubscribersListModel
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: NewsletterAdminRoutes.subscribers.description
                        )
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Subscribers",
                        description: "Manage newsletter subscribers."
                    )
                )
            )
            context.render(
                NewsletterSubscribersTableContent(
                    model: model,
                    permissions: permissions
                )
            )
        }
        .class("cms-section")
    }
}
