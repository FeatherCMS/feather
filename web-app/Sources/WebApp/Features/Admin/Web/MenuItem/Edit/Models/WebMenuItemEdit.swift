import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuItemEdit: Component {

    struct State {
        let menuId: String
        let id: String
        let isEdited: Bool
        let form: WebMenuItemForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit item")
            if state.isEdited { P("Item edited successfully.") }
            WebMenuItemForm(
                state: state.form,
                action:
                    "/admin/web/menus/\(state.menuId)/items/\(state.id)/edit/",
                submitLabel: "Edit item",
                removeHref:
                    "/admin/web/menus/\(state.menuId)/items/\(state.id)/remove/",
                removeLabel: "Remove item"
            )
        }
        .class("cms-section")
    }
}
