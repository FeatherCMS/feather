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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Redirect rule details")
            AdminDetailsField(label: "ID", value: state.rule.id).html()
            AdminDetailsField(label: "Source", value: state.rule.source).html()
            AdminDetailsField(
                label: "Destination",
                value: state.rule.destination
            ).html()
            AdminDetailsField(
                label: "Status code",
                value: "\(state.rule.statusCode)"
            ).html()
            AdminDetailsField(label: "Notes", value: state.rule.notes ?? "").html()
            Div {
                AdminNavigationButton(
                    "Edit rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove rule",
                    href: "/admin/redirect/rules/\(state.rule.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
