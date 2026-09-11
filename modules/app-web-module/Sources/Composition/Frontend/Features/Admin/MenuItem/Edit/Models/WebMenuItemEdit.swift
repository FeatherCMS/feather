import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemEdit: Component {

    struct State {
        let menuId: String
        let id: String
        let isEdited: Bool
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit item")
            context.render(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            if state.isEdited { P("Item edited successfully.") }
            context.render(
                WebMenuItemForm(
                    state: state.form,
                    action:
                        "/admin/web/menus/\(state.menuId)/items/\(state.id)/edit/",
                    submitLabel: "Edit item",
                    removeHref:
                        "/admin/web/menus/\(state.menuId)/items/\(state.id)/remove/",
                    removeLabel: "Remove item"
                )
            )
        }
        .class("cms-section")
    }
}
