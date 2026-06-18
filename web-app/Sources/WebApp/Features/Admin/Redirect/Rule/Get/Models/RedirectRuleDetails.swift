import HTML
import SGML
import WebStandards

struct RedirectRuleDetails: Component {
    struct State {
        let rule: RedirectRuleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Redirect rule details")
            AdminDetailsField(label: "ID", value: state.rule.id)
            AdminDetailsField(label: "Source", value: state.rule.source)
            AdminDetailsField(
                label: "Destination",
                value: state.rule.destination
            )
            AdminDetailsField(
                label: "Status code",
                value: "\(state.rule.statusCode)"
            )
            AdminDetailsField(label: "Notes", value: state.rule.notes)
            Div {
                AdminNavigationButton(
                    "Edit rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
