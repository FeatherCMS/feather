import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscriberRow: Component {
    let newsletterId: String
    let item: AdminNewsletterCampaignSubscriberItem
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(Permissions.Subscribers.delete) {
                context.build(AdminListRowCheckbox(id: item.id))
            }
            Td(item.email)
                .data("label", "Email")
                .data("remove-label", "true")
            Td("\(item.firstName) \(item.lastName)").data("label", "Name")
            Td(item.status).data("label", "Status")
            context.build(
                AdminListRowActions(
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
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
