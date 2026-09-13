import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleDetails: Component {
    let rule: RedirectRuleDetailsModel
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: RedirectRuleRoutes.breadcrumb,
                    pageHeader: .init(
                        title: "Redirect rule details",
                        description: "Review the redirect rule configuration."
                    ),
                    fields: [
                        .init(label: "ID", value: rule.id),
                        .init(label: "Source", value: rule.source),
                        .init(label: "Destination", value: rule.destination),
                        .init(
                            label: "Status code",
                            value: String(rule.statusCode.rawValue)
                        ),
                        .init(label: "Notes", value: rule.notes ?? "—"),
                    ],
                    actions: actions
                )
            )
        }
        .class("cms-section")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(RedirectPermissions.Rules.update) {
            result.append(
                .init(
                    label: "Edit rule",
                    href: RedirectRuleRoutes.edit(RouterPath(rule.id))
                        .description,
                    style: .primary
                )
            )
        }
        if permissions.allows(RedirectPermissions.Rules.delete) {
            result.append(
                .init(
                    label: "Remove rule",
                    href: RedirectRuleRoutes.remove(RouterPath(rule.id))
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }
}
