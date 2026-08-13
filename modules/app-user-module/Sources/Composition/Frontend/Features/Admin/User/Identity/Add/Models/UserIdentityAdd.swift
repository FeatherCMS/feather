import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebStandards

struct UserIdentityAdd: Component {

    struct State {
        let form: UserIdentityForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add identity")

            UserIdentityForm(
                state: state.form,
                action: "/admin/user/identities/add/",
                submitLabel: "Add identity"
            )
        }
        .class("cms-section")
    }
}
