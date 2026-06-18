import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthMagicLinkAdd: Component {

    struct State {
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add user magic link")
            AuthMagicLinkForm(
                state: state.form,
                action: "/admin/auth/magic-links/add/",
                submitLabel: "Add magic link"
            )
        }
        .class("cms-section")
    }
}
