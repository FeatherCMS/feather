import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscriberRow: Component {
    let item: Subscriber.List.Model.Item
    let permissions: AdminListActions
    let returnTo: String
    let routes: Subscriber.Router.Routes

    func html(context: inout BuilderContext) -> Tr {
        var actions: [AdminListRowActions.Action] = [
            .init(
                "View",
                href:
                    routes.detailsPath(item.id),
                style: .ghost(.primary),
                permission: Subscriber.Permissions.read
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
                    permission: Subscriber.Permissions.update
                )
            )
        }
        return Tr {
            if permissions.allows(Subscriber.Permissions.delete) {
                context.build(AdminListRowCheckbox(id: item.id))
            }
            Td(item.email)
                .data("label", "Email")
                .data("remove-label", "true")
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
