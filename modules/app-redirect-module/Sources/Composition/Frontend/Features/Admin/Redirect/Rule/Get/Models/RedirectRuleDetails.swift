import FeatherAdmin
import Foundation
import HTML
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleDetails: Leaf {
    struct State {
        let rule: RedirectRuleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Redirect rule details")
            AdminDetailsField(label: "ID", value: state.rule.id).renderHTML()
            AdminDetailsField(label: "Source", value: state.rule.source).renderHTML()
            AdminDetailsField(
                label: "Destination",
                value: state.rule.destination
            ).renderHTML()
            AdminDetailsField(
                label: "Status code",
                value: "\(state.rule.statusCode)"
            ).renderHTML()
            AdminDetailsField(label: "Notes", value: state.rule.notes ?? "").renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
