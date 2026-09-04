import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuItemAdd: Leaf {

    struct State {
        let menuId: String
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add item")
            AdminWebMenuTabs(menuID: state.menuId, active: .items).renderHTML()
            WebMenuItemForm(
                state: state.form,
                action: "/admin/web/menus/\(state.menuId)/items/add/",
                submitLabel: "Add item"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
