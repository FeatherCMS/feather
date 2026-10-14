import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscriberRow: Component {
    let item: AdminNewsletterSubscriberListItem
    let permissions: AdminListActions
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        var actions: [AdminListRowActions.Action] = [
            .init(
                "View",
                href:
                    NewsletterAdminRoutes.subscriberDetails(
                        RouterPath(item.id)
                    )
                    .description,
                style: .ghost(.primary),
                permission: Permissions.Subscribers.read
            )
        ]
        if let campaign = item.newsletters.first {
            actions.append(
                .init(
                    "Edit",
                    href:
                        NewsletterAdminRoutes.campaignSubscriberEdit(
                            newsletterID: RouterPath(campaign.id),
                            subscriberID: RouterPath(item.id)
                        )
                        .description,
                    style: .ghost(.secondary),
                    permission: Permissions.Subscribers.update
                )
            )
        }
        actions.append(
            .init(
                "Remove",
                href: AdminLocation.remove(
                    path: NewsletterAdminRoutes.subscriberRemove.description,
                    ids: [item.id],
                    returnTo: returnTo
                ),
                style: .destructive,
                permission: Permissions.Subscribers.delete
            )
        )
        return Tr {
            if permissions.allows(Permissions.Subscribers.delete) {
                context.build(AdminListRowCheckbox(id: item.id))
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
                AdminListRowActions(
                    label: "Actions",
                    actions: actions,
                    permissions: permissions
                )
            )
        }
    }
}
