import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuItemAdd: Component {

    struct State {
        let menuId: String
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add item")
            WebMenuItemForm(
                state: state.form,
                action: "/admin/web/menus/\(state.menuId)/items/add/",
                submitLabel: "Add item"
            )
        }
        .class("cms-section")
    }
}
