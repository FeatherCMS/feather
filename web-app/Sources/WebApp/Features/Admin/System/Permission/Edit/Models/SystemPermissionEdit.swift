import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemPermissionEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: SystemPermissionForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit system permission")
            if state.isEdited { P("System permission edited successfully.") }
            SystemPermissionForm(
                state: state.form,
                action: "/admin/system/permissions/\(state.id)/edit/",
                submitLabel: "Edit permission",
                removeHref: "/admin/system/permissions/\(state.id)/remove/",
                removeLabel: "Remove permission"
            )
        }
        .class("cms-section")
    }
}
