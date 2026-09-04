import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct BlogAuthorLinkDetails: Leaf {
    struct State {
        let rule: BlogAuthorLinkDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Blog author link details")
            AdminDetailsField(label: "ID", value: state.rule.id).renderHTML()
            AdminDetailsField(label: "Label", value: state.rule.label).renderHTML()
            AdminDetailsField(label: "URL", value: state.rule.url).renderHTML()
            AdminDetailsField(
                label: "Priority",
                value: "\(state.rule.priority)"
            ).renderHTML()
            AdminDetailsField(
                label: "Blank target",
                value: state.rule.isBlank ? "Yes" : "No"
            ).renderHTML()
            AdminDetailsField(label: "Permission", value: state.rule.permission).renderHTML()
            AdminDetailsField(label: "Notes", value: state.rule.notes).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/blog/authors/\(state.rule.menuId)/links/\(state.rule.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/blog/authors/\(state.rule.menuId)/links/\(state.rule.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
