import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit menu")
            AdminWebMenuTabs(menuID: state.id, active: .details).renderHTML()
            if state.isEdited { P("Menu edited successfully.") }
            WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/\(state.id)/edit/",
                submitLabel: "Edit menu",
                removeHref: "/admin/web/menus/\(state.id)/remove/",
                removeLabel: "Remove menu"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
