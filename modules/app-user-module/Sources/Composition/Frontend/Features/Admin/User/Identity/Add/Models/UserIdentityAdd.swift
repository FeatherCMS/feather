import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebComponents
import WebBuilders

struct UserIdentityAdd: Leaf {

    struct State {
        let form: UserIdentityForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add identity")

            UserIdentityForm(
                state: state.form,
                action: "/admin/user/identities/add/",
                submitLabel: "Add identity"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
