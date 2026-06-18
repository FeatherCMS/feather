import HTML
import SGML
import WebStandards

struct WebMenuItemDetails: Component {
    struct State {
        let rule: WebMenuItemDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Item details")
            AdminDetailsField(label: "ID", value: state.rule.id)
            AdminDetailsField(label: "Label", value: state.rule.label)
            AdminDetailsField(label: "URL", value: state.rule.url)
            AdminDetailsField(
                label: "Priority",
                value: "\(state.rule.priority)"
            )
            AdminDetailsField(
                label: "Blank target",
                value: state.rule.isBlank ? "Yes" : "No"
            )
            AdminDetailsField(label: "Permission", value: state.rule.permission)
            AdminDetailsField(label: "Notes", value: state.rule.notes)
            Div {
                AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/web/menus/\(state.rule.menuId)/items/\(state.rule.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/web/menus/\(state.rule.menuId)/items/\(state.rule.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
