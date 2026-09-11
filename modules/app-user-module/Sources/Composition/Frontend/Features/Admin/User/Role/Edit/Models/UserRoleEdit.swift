import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserRoleEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: UserRoleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit user role")
            if state.isEdited { P("User role edited successfully.") }
            context.render(
                UserRoleForm(
                    state: state.form,
                    action: "/admin/user/roles/\(state.id)/edit/",
                    submitLabel: "Edit role",
                    removeHref: "/admin/user/roles/\(state.id)/remove/",
                    removeLabel: "Remove role"
                )
            )
        }
        .class("cms-section")
    }
}
