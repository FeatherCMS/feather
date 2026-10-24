import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import WebBuilders
import WebComponents

extension Subscriber.View {
    struct Details: Component {
        let model: Subscriber.View.Model
        let permissions: AdminListActions
        let routes: Subscriber.Router.Routes

        func html(context: inout BuilderContext) -> Section {
            var actions: [AdminDetailView.Action] = []
            if permissions.allows(Subscriber.Permissions.update) {
                for campaign in model.newsletters {
                    actions.append(
                        .init(
                            label: "Edit",
                            href: routes.campaigns.subscriberEditPath(
                                newsletterId: campaign.id,
                                subscriberId: model.id
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
                            ids: [model.id],
                            returnTo: routes.detailsPath(model.id)
                        ),
                        style: .destructive
                    )
                )
            }
            return context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb + [
                        .init(label: "Subscribers", link: routes.list.path)
                    ],
                    pageHeader: .primary(
                        title: "Subscriber details",
                        description:
                            "Review campaign subscriptions for this email address."
                    ),
                    fields: [
                        .init(label: "Email", value: model.email),
                        .init(label: "Name", value: model.name),
                        .init(
                            label: "Campaigns",
                            value: model.newsletters
                                .map { "\($0.name) (\($0.status))" }
                                .joined(separator: ", ")
                        ),
                    ],
                    actions: actions
                )
            )
        }
    }
}
