import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableAdd: Leaf {

    struct State {
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add system variable")
            SystemVariableForm(
                state: state.form,
                action: "/admin/system/variables/add/",
                submitLabel: "Add variable"
            ).html()
        }
        .class("cms-section")
    }
}
