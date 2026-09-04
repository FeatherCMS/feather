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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add item")
            AdminWebMenuTabs(menuID: state.menuId, active: .items).html()
            WebMenuItemForm(
                state: state.form,
                action: "/admin/web/menus/\(state.menuId)/items/add/",
                submitLabel: "Add item"
            ).html()
        }
        .class("cms-section")
    }
}
