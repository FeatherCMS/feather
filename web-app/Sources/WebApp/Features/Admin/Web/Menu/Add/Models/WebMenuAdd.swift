import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuAdd: Component {

    struct State {
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add menu")
            WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/add/",
                submitLabel: "Add menu"
            )
        }
        .class("cms-section")
    }
}
