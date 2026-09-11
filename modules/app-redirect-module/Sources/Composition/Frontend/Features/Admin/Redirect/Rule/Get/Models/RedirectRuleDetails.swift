import FeatherAdmin
import Foundation
import HTML
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleDetails: Component {
    struct State {
        let rule: RedirectRuleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Redirect rule details")
            context.render(AdminDetailsField(label: "ID", value: state.rule.id))
            context.render(AdminDetailsField(label: "Source", value: state.rule.source))
            context.render(AdminDetailsField(
                label: "Destination",
                value: state.rule.destination
            ))
            context.render(AdminDetailsField(
                label: "Status code",
                value: "\(state.rule.statusCode)"
            ))
            context.render(AdminDetailsField(label: "Notes", value: state.rule.notes ?? ""))
            Div {
                context.render(AdminNavigationButton(
                    "Edit rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
