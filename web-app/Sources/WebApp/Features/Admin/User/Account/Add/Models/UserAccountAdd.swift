import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserAccountAdd: Component {

    struct State {
        let form: UserAccountForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add account")

            UserAccountForm(
                state: state.form,
                action: "/admin/user/accounts/add/",
                submitLabel: "Add account"
            )
        }
        .class("cms-section")
    }
}
