import FeatherAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectContracts
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleRow: Component {
    let rule: RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema
    let returnTo: String
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(RedirectPermissions.Rules.delete) {
                context.render(NewAdminListRowCheckbox(id: rule.id))
            }
            Td(rule.source).data("label", "Source").columnWidth(percent: 24)
            Td(rule.destination).data("label", "Destination")
                .columnWidth(percent: 40)
            Td(String(rule.statusCode)).data("label", "Status")
                .columnWidth(percent: 10)
            context.render(
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
