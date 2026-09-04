import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: SystemVariableForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit system variable")
            if state.isEdited { P("System variable edited successfully.") }
            SystemVariableForm(
                state: state.form,
                action: "/admin/system/variables/\(state.id)/edit/",
                submitLabel: "Edit variable",
                removeHref: "/admin/system/variables/\(state.id)/remove/",
                removeLabel: "Remove variable"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
