import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemVariableAdd: Component {

    struct State {
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add system variable")
            SystemVariableForm(
                state: state.form,
                action: "/admin/system/variables/add/",
                submitLabel: "Add variable"
            )
        }
        .class("cms-section")
    }
}
