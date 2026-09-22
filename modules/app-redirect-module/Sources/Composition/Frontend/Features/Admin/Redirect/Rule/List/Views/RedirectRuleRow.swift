import FeatherAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleRow: Component {
    let rule: RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema
    let returnTo: String
    let permissions: NewAdminListActions

    private var statusChip: NewAdminChip {
        guard let statusCode = StatusCode(rawValue: rule.statusCode) else {
            return NewAdminChip(
                label: String(rule.statusCode),
                color: .red
            )
        }

        return switch statusCode {
        case .movedPermanently:
            NewAdminChip(label: "301 Moved Permanently", color: .green)
        case .found:
            NewAdminChip(label: "302 Found", color: .blue)
        case .temporaryRedirect:
            NewAdminChip(label: "307 Temporary Redirect", color: .orange)
        case .permanentRedirect:
            NewAdminChip(label: "308 Permanent Redirect", color: .red)
        }
    }

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(RedirectPermissions.Rules.delete) {
                context.build(NewAdminListRowCheckbox(id: rule.id))
            }
            Td(rule.source).data("label", "Source")
            Td(rule.destination).data("label", "Destination")
            Td {
                context.build(statusChip)
            }
            .data("label", "Status")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href:
                                RedirectRuleRoutes.details(RouterPath(rule.id))
                                .description,
                            style: .ghost(.primary),
                            permission: RedirectPermissions.Rules.read
                        ),
                        .init(
                            "Edit",
                            href: RedirectRuleRoutes.edit(RouterPath(rule.id))
                                .description,
                            style: .ghost(.secondary),
                            permission: RedirectPermissions.Rules.update
                        ),
                        .init(
                            "Remove",
                            href: NewAdminLocation.remove(
                                path: RedirectRuleRoutes.remove.description,
                                ids: [rule.id],
                                returnTo: returnTo
                            ),
                            style: .destructive,
                            permission: RedirectPermissions.Rules.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
