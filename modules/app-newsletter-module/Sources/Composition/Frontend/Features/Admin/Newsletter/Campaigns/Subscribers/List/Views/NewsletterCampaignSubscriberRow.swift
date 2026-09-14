import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscriberRow: Component {
    let newsletterId: String
    let item: AdminNewsletterCampaignSubscriberItem
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(Permissions.Subscribers.delete) {
                context.render(NewAdminListRowCheckbox(id: item.id))
            }
            Td(item.email).data("label", "Email")
            Td("\(item.firstName) \(item.lastName)").data("label", "Name")
            Td(item.status).data("label", "Status")
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "Edit",
                            href:
                                NewsletterAdminRoutes.campaignSubscriberEdit(
                                    newsletterID: RouterPath(newsletterId),
                                    subscriberID: RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.secondary),
                            permission: Permissions.Subscribers.update
                        ),
                        .init(
                            "Remove",
                            href:
                                NewsletterAdminRoutes.campaignSubscriberRemove(
                                    newsletterID: RouterPath(newsletterId),
                                    subscriberID: RouterPath(item.id)
                                )
                                .description,
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
