import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebMenuItemDetails: Leaf {
    struct State {
        let item: WebMenuItemDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Item details")
            AdminDetailsField(label: "ID", value: state.item.id).renderHTML()
            AdminDetailsField(label: "Label", value: state.item.label).renderHTML()
            AdminDetailsField(label: "URL", value: state.item.url).renderHTML()
            AdminDetailsField(
                label: "Priority",
                value: "\(state.item.priority)"
            ).renderHTML()
            AdminDetailsField(
                label: "Blank target",
                value: state.item.isBlank ? "Yes" : "No"
            ).renderHTML()
            AdminDetailsField(label: "Permission", value: state.item.permission).renderHTML()
            AdminDetailsField(
                label: "Authentication",
                value: state.item.authentication
            ).renderHTML()
            AdminDetailsField(label: "Notes", value: state.item.notes ?? "").renderHTML()

            Div {
                AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
