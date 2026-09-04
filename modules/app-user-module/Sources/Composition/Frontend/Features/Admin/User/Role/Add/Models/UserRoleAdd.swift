import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebComponents
import WebBuilders

struct UserRoleAdd: Leaf {

    struct State {
        let form: UserRoleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add user role")
            UserRoleForm(
                state: state.form,
                action: "/admin/user/roles/add/",
                submitLabel: "Add role"
            ).html()
        }
        .class("cms-section")
    }
}
