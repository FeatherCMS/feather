import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebComponents
import WebBuilders

struct UserRoleEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: UserRoleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit user role")
            if state.isEdited { P("User role edited successfully.") }
            UserRoleForm(
                state: state.form,
                action: "/admin/user/roles/\(state.id)/edit/",
                submitLabel: "Edit role",
                removeHref: "/admin/user/roles/\(state.id)/remove/",
                removeLabel: "Remove role"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
