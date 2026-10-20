import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleRow: Component {
    let rule: RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema
    let returnTo: String
    let permissions: AdminListActions

    private var statusChip: AdminChip {
        guard let statusCode = StatusCode(rawValue: rule.statusCode) else {
            return AdminChip(
                label: String(rule.statusCode),
                color: .red
            )
        }

        return switch statusCode {
        case .movedPermanently:
            AdminChip(label: "301 Moved Permanently", color: .green)
        case .found:
            AdminChip(label: "302 Found", color: .blue)
        case .temporaryRedirect:
            AdminChip(label: "307 Temporary Redirect", color: .orange)
        case .permanentRedirect:
            AdminChip(label: "308 Permanent Redirect", color: .red)
        }
    }

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(RedirectPermissions.Rules.delete) {
                context.build(AdminListRowCheckbox(id: rule.id))
            }
            Td(rule.source)
                .data("label", "Source")
                .data("remove-label", "true")
            Td(rule.destination).data("label", "Destination")
            Td {
                context.build(statusChip)
            }
            .data("label", "Status")
            context.build(
                AdminListRowActions(
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
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
