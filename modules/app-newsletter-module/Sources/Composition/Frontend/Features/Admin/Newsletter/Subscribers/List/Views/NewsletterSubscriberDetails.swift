import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscriberDetails: Component {
    let item: AdminNewsletterSubscriberListItem
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if permissions.allows(Permissions.Subscribers.update) {
            for campaign in item.newsletters {
                actions.append(
                    .init(
                        label: "Edit",
                        href:
                            NewsletterAdminRoutes.campaignSubscriberEdit(
                                newsletterID: RouterPath(campaign.id),
                                subscriberID: RouterPath(item.id)
                            )
                            .description,
                        style: .secondary
                    )
                )
            }
        }
        if permissions.allows(Permissions.Subscribers.delete) {
            actions.append(
                .init(
                    label: "Remove",
                    href: NewAdminLocation.remove(
                        path: NewsletterAdminRoutes.subscriberRemove
                            .description,
                        ids: [item.id],
                        returnTo:
                            NewsletterAdminRoutes.subscriberDetails(
                                RouterPath(item.id)
                            )
                            .description
                    ),
                    style: .destructive
                )
            )
        }
        return context.build(
            NewAdminDetailView(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Subscribers",
                        link: NewsletterAdminRoutes.subscribers.description
                    )
                ],
                pageHeader: .init(
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
