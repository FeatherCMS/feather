import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import WebBuilders
import WebComponents

extension Campaign.Search.Table {
    struct Row: Component {
        let item: Campaign.Item
        let actions: AdminListActions
        let returnTo: String
        let isPicker: Bool
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            let canDelete = actions.allows(Campaign.Permissions.delete)

            return Tr {
                if canDelete {
                    context.build(AdminListRowCheckbox(id: item.id))
                }
                identifierCell(context: &context)
                if isPicker {
                    Td {
                        Button(item.name)
                            .type(.button)
                            .data("mce-picker-item", item.id)
                            .data("mce-picker-label", item.name)
                    }
                    .data("label", "Name")
                }
                else {
                    Td(item.name)
                        .data("label", "Name")
                        .setAsRemoveConfirmationLabel()
                }
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "View",
                                href:
                                    routes.detailsPath(item.id),
                                style: .ghost(.primary),
                                permission: Campaign.Permissions.read
                            ),
                            .init(
                                "Edit",
                                href:
                                    routes.editPath(item.id),
                                style: .ghost(.secondary),
                                permission: Campaign.Permissions.update
                            ),
                        ],
                        permissions: actions
                    )
                )
            }
        }

        private func identifierCell(context: inout BuilderContext) -> Td {
            Td {
                Span {
                    Span(item.id)
                    if actions.allows(Campaign.Permissions.read) {
                        context.build(
                            AdminCopyButton(
                                value: "@NewsletterCampaign(key: \(item.id))",
                                label: "Copy campaign key \(item.id)",
                                copiedMessage:
                                    "Newsletter campaign key copied to clipboard"
                            )
                        )
                    }
                }
                .style(
                    "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;"
                )
            }
            .data("label", "Key")
        }
    }
}
