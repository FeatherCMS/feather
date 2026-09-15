import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscriberRow: Component {
    let item: AdminNewsletterSubscriberListItem
    let permissions: NewAdminListActions
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(Permissions.Subscribers.delete) {
                context.build(NewAdminListRowCheckbox(id: item.id))
            }
            Td(item.email).data("label", "Email")
            Td(item.name).data("label", "Name")
            Td {
                for campaign in item.newsletters {
                    A("\(campaign.name) (\(campaign.status))")
                        .href(
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(campaign.id)
                            )
                            .description
                        )
                    Br()
                }
            }
            .data("label", "Campaigns")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href: NewsletterAdminRoutes.subscribers.description
                                + "/\(item.id)/",
                            style: .ghost(.primary),
                            permission: Permissions.Subscribers.read
                        ),
                        .init(
                            "Remove",
                            href: NewAdminLocation.remove(
                                path: NewsletterAdminRoutes.subscriberRemove
                                    .description,
                                ids: [item.id],
                                returnTo: returnTo
                            ),
                            style: .destructive,
                            permission: Permissions.Subscribers.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
