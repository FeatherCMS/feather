import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectModule
import WebBuilders
import WebComponents

struct RedirectRuleRow: Component {
    let rule: RedirectAdminAPI.Components.Schemas.RedirectRuleQueryItemSchema
    let returnTo: String
    let permissions: AdminListActions
    let routes: RedirectModule.Rule.Router.Routes

    private var statusChip: AdminChip {
        guard let statusCode = RedirectModule.Rule.StatusCode(rawValue: rule.statusCode) else {
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
            if permissions.allows(RedirectModule.Rule.Permissions.delete) {
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
                            href: routes.detailsPath(rule.id),
                            style: .ghost(.primary),
                            permission: RedirectModule.Rule.Permissions.read
                        ),
                        .init(
                            "Edit",
                            href: routes.editPath(rule.id),
                            style: .ghost(.secondary),
                            permission: RedirectModule.Rule.Permissions.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
