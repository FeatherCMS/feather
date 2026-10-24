import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List {
    struct Details: Component {
        let item: Subscriber.List.Model.Item
        let permissions: AdminListActions
        let routes: Subscriber.Router.Routes

        func html(context: inout BuilderContext) -> Section {
            var actions: [AdminDetailView.Action] = []
            if permissions.allows(Subscriber.Permissions.update) {
                for campaign in item.newsletters {
                    actions.append(
                        .init(
                            label: "Edit",
                            href:
                                routes.campaigns.subscriberEditPath(
                                    newsletterId: campaign.id,
                                    subscriberId: item.id
                                ),
                            style: .secondary
                        )
                    )
                }
            }
            if permissions.allows(Subscriber.Permissions.delete) {
                actions.append(
                    .init(
                        label: "Remove",
                        href: AdminLocation.remove(
                            path: routes.remove.path,
                            ids: [item.id],
                            returnTo:
                                routes.detailsPath(item.id)
                        ),
                        style: .destructive
                    )
                )
            }
            return context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: routes.list.path
                        )
                    ],
                    pageHeader: .primary(
                        title: "Subscriber details",
                        description:
                            "Review campaign subscriptions for this email address."
                    ),
                    fields: [
                        .init(label: "Email", value: item.email),
                        .init(label: "Name", value: item.name),
                        .init(
                            label: "Campaigns",
                            value: item.newsletters
                                .map {
                                    "\($0.name) (\($0.status))"
                                }
                                .joined(separator: ", ")
                        ),
                    ],
                    actions: actions
                )
            )
        }
    }
}
