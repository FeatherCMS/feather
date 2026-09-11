import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit system variable")
            if state.isEdited { P("System variable edited successfully.") }
            context.render(SystemVariableForm(
                state: state.form,
                action: "/admin/system/variables/\(state.id)/edit/",
                submitLabel: "Edit variable",
                removeHref: "/admin/system/variables/\(state.id)/remove/",
                removeLabel: "Remove variable"
            ))
        }
        .class("cms-section")
    }
}
