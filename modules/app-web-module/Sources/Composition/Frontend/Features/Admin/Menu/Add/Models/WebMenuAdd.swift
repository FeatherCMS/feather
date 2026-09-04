import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuAdd: Leaf {

    struct State {
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add menu")
            WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/add/",
                submitLabel: "Add menu"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
