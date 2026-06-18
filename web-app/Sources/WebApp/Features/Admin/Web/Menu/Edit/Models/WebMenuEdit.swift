import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit menu")
            if state.isEdited { P("Menu edited successfully.") }
            WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/\(state.id)/edit/",
                submitLabel: "Edit menu",
                removeHref: "/admin/web/menus/\(state.id)/remove/",
                removeLabel: "Remove menu"
            )
        }
        .class("cms-section")
    }
}
