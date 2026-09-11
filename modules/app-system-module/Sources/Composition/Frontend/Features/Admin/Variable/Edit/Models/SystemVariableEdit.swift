import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemVariableEdit: Component {

    struct State {
        let id: String
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit system variable")
            context.render(
                SystemVariableForm(
                    state: state.form,
                    action: SystemVariableRoutes.edit(RouterPath(state.id))
                        .description,
                    submitLabel: "Edit variable",
                    removeHref: SystemVariableRoutes.remove(state.id),
                    removeLabel: "Remove variable"
                )
            )
        }
        .class("cms-section")
    }
}
