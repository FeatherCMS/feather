import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserRoleEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: UserRoleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit user role")
            if state.isEdited { P("User role edited successfully.") }
            UserRoleForm(
                state: state.form,
                action: "/admin/user/roles/\(state.id)/edit/",
                submitLabel: "Edit role",
                removeHref: "/admin/user/roles/\(state.id)/remove/",
                removeLabel: "Remove role"
            )
        }
        .class("cms-section")
    }
}
