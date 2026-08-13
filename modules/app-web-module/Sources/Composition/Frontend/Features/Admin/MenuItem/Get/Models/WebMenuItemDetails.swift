import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebStandards

struct WebMenuItemDetails: Component {
    struct State {
        let item: WebMenuItemDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Item details")
            AdminDetailsField(label: "ID", value: state.item.id)
            AdminDetailsField(label: "Label", value: state.item.label)
            AdminDetailsField(label: "URL", value: state.item.url)
            AdminDetailsField(
                label: "Priority",
                value: "\(state.item.priority)"
            )
            AdminDetailsField(
                label: "Blank target",
                value: state.item.isBlank ? "Yes" : "No"
            )
            AdminDetailsField(label: "Permission", value: state.item.permission)
            AdminDetailsField(
                label: "Authentication",
                value: state.item.authentication
            )
            AdminDetailsField(label: "Notes", value: state.item.notes ?? "")

            Div {
                AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
