import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemAdd: Component {

    struct State {
        let menuId: String
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add item")
            context.render(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.render(
                WebMenuItemForm(
                    state: state.form,
                    action: "/admin/web/menus/\(state.menuId)/items/add/",
                    submitLabel: "Add item"
                )
            )
        }
        .class("cms-section")
    }
}
