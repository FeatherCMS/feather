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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Item details")
            AdminDetailsField(label: "ID", value: state.item.id).html()
            AdminDetailsField(label: "Label", value: state.item.label).html()
            AdminDetailsField(label: "URL", value: state.item.url).html()
            AdminDetailsField(
                label: "Priority",
                value: "\(state.item.priority)"
            ).html()
            AdminDetailsField(
                label: "Blank target",
                value: state.item.isBlank ? "Yes" : "No"
            ).html()
            AdminDetailsField(label: "Permission", value: state.item.permission).html()
            AdminDetailsField(
                label: "Authentication",
                value: state.item.authentication
            ).html()
            AdminDetailsField(label: "Notes", value: state.item.notes ?? "").html()

            Div {
                AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
