import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthCredentialEdit: Component {
    struct State {
        let id: String
        let form: AuthCredentialForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit user credential")
            AuthCredentialForm(
                state: state.form,
                action: "/admin/auth/credentials/\(state.id)/edit/",
                submitLabel: "Edit credential",
                removeHref: "/admin/auth/credentials/\(state.id)/remove/"
            )
        }
        .class("cms-section")
    }
}
