import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import WebBuilders
import WebComponents

struct NewsletterCampaignRow: Component {
    let item: AdminNewsletterCampaignItem
    let actions: NewAdminListActions
    let returnTo: String
    let isPicker: Bool

    func html(context: inout BuilderContext) -> Tr {
        let canDelete = actions.allows(Permissions.Campaigns.delete)

        return Tr {
            if canDelete {
                context.build(NewAdminListRowCheckbox(id: item.id))
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
                Td(item.name).data("label", "Name")
            }
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href:
                                NewsletterAdminRoutes.campaignDetails(
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.primary),
                            permission: Permissions.Campaigns.read
                        ),
                        .init(
                            "Edit",
                            href:
                                NewsletterAdminRoutes.campaignEdit(
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.secondary),
                            permission: Permissions.Campaigns.update
                        ),
                        .init(
                            "Remove",
                            href: NewAdminLocation.remove(
                                path: NewsletterAdminRoutes.campaignRemove
                                    .description,
                                ids: [item.id],
                                returnTo: returnTo
                            ),
                            style: .destructive,
                            permission: Permissions.Campaigns.delete
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
                if actions.allows(Permissions.Campaigns.read) {
                    Button {
                        FeatherIcons.clipboard()
                    }
                    .type(.button)
                    .ariaLabel("Copy campaign identifier \(item.id)")
                    .onClick(
                        "navigator.clipboard.writeText('@NewsletterCampaign(id: \(item.id))').then(()=>window.toast&&window.toast.success('Copied','Newsletter identifier copied to clipboard'))"
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
        .data("label", "ID")
    }
}
