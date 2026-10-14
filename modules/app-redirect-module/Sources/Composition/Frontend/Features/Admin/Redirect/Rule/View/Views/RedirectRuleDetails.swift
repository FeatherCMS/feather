import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleDetails: Component {
    let rule: RedirectRuleDetailsModel
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: RedirectRuleRoutes.breadcrumb,
                    pageHeader: .primary(
                        title: "Redirect rule details",
                        description: "Review the redirect rule configuration."
                    ),
                    fields: [
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

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
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
