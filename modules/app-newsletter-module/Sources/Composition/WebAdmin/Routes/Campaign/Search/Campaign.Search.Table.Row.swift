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
                identifierCell()
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

        private func identifierCell() -> Td {
            Td {
                Span {
                    Span(item.id)
                    if actions.allows(Campaign.Permissions.read) {
                        Button {
                            FeatherIcons.clipboard()
                        }
                        .type(.button)
                        .ariaLabel("Copy campaign key \(item.id)")
                        .onClick(
                            "navigator.clipboard.writeText('@NewsletterCampaign(key: \(item.id))').then(()=>window.toast&&window.toast.success('Copied','Newsletter campaign key copied to clipboard'))"
                        )
                        .style(
                            "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;padding:0;border:0;background:transparent;color:var(--cms-link);cursor:pointer;"
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
