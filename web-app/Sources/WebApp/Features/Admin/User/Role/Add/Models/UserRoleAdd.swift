import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserRoleAdd: Component {

    struct State {
        let form: UserRoleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add user role")
            UserRoleForm(
                state: state.form,
                action: "/admin/user/roles/add/",
                submitLabel: "Add role"
            )
        }
        .class("cms-section")
    }
}
