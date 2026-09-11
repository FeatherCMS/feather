import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebMenuItemDetails: Component {
    struct State {
        let item: WebMenuItemDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Item details")
            context.render(AdminDetailsField(label: "ID", value: state.item.id))
            context.render(AdminDetailsField(label: "Label", value: state.item.label))
            context.render(AdminDetailsField(label: "URL", value: state.item.url))
            context.render(AdminDetailsField(
                label: "Priority",
                value: "\(state.item.priority)"
            ))
            context.render(AdminDetailsField(
                label: "Blank target",
                value: state.item.isBlank ? "Yes" : "No"
            ))
            context.render(AdminDetailsField(label: "Permission", value: state.item.permission))
            context.render(AdminDetailsField(
                label: "Authentication",
                value: state.item.authentication
            ))
            context.render(AdminDetailsField(label: "Notes", value: state.item.notes ?? ""))

            Div {
                context.render(AdminNavigationButton(
                    "Edit item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove item",
                    href:
                        "/admin/web/menus/\(state.item.menuId)/items/\(state.item.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
