import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectModule
import WebBuilders
import WebComponents

struct RedirectRuleDetails: Component {
    let rule: RedirectRuleDetailsModel
    let permissions: AdminListActions
    let routes: Rule.Router.Routes

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb,
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
        if permissions.allows(Rule.Permissions.update) {
            result.append(
                .init(
                    label: "Edit rule",
                    href: routes.editPath(rule.id),
                    style: .primary
                )
            )
        }
        if permissions.allows(Rule.Permissions.delete) {
            result.append(
                .init(
                    label: "Remove rule",
                    href: routes.removePath(rule.id),
                    style: .destructive
                )
            )
        }
        return result
    }
}
