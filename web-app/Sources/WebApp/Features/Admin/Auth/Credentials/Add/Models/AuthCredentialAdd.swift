import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthCredentialAdd: Component {
    struct State {
        let accountID: String
        let form: AuthCredentialForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add user credential")
            AuthCredentialForm(
                state: state.form,
                action: "/admin/auth/credentials/\(state.accountID)/add/",
                submitLabel: "Add credential",
                removeHref: nil
            )
        }
        .class("cms-section")
    }
}
