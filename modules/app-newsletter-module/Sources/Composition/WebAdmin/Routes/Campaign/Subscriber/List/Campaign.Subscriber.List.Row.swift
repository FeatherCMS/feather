import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscriber.List {
    struct Row: Component {
        let newsletterId: String
        let item: Item
        let permissions: AdminListActions
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if permissions.allows(Subscriber.Permissions.delete) {
                    context.build(AdminListRowCheckbox(id: item.id))
                }
                Td(item.email)
                    .data("label", "Email")
                    .data("remove-label", "true")
                Td(item.name).data("label", "Name")
                Td(item.status).data("label", "Status")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "Edit",
                                href: routes.subscriberEditPath(
                                    newsletterId: newsletterId,
                                    subscriberId: item.id
                                ),
                                style: .ghost(.secondary),
                                permission: Subscriber.Permissions.update
                            )
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
