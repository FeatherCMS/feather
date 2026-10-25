import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectApplication
import RedirectModule
import RedirectDomain
import WebBuilders
import WebComponents

extension Rule.List {
    struct Row: Component {
        let rule:
            RedirectAdminAPI.Components.Schemas.RedirectRuleQueryItemSchema
        let returnTo: String
        let permissions: AdminListActions
        let routes: Rule.Router.Routes

        private var statusChip: AdminChip {
            guard let statusCode = Rule.Model.StatusCode(rawValue: rule.statusCode)
            else {
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
                if permissions.allows(Rule.Permissions.delete) {
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
                                permission: Rule.Permissions.read
                            ),
                            .init(
                                "Edit",
                                href: routes.editPath(rule.id),
                                style: .ghost(.secondary),
                                permission: Rule.Permissions.update
                            ),
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
