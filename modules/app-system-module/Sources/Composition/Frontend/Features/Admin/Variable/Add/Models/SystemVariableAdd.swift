import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableAdd: Component {

    struct State {
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add system variable")
            context.render(SystemVariableForm(
                state: state.form,
                action: "/admin/system/variables/add/",
                submitLabel: "Add variable"
            ))
        }
        .class("cms-section")
    }
}
