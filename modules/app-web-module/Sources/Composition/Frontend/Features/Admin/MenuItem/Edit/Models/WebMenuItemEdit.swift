import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuItemEdit: Leaf {

    struct State {
        let menuId: String
        let id: String
        let isEdited: Bool
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Edit item")
            AdminWebMenuTabs(menuID: state.menuId, active: .items).html()
            if state.isEdited { P("Item edited successfully.") }
            WebMenuItemForm(
                state: state.form,
                action:
                    "/admin/web/menus/\(state.menuId)/items/\(state.id)/edit/",
                submitLabel: "Edit item",
                removeHref:
                    "/admin/web/menus/\(state.menuId)/items/\(state.id)/remove/",
                removeLabel: "Remove item"
            ).html()
        }
        .class("cms-section")
    }
}
