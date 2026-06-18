import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthMagicLinkEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit user magic link")
            if state.isEdited { P("User magic link edited successfully.") }
            AuthMagicLinkForm(
                state: state.form,
                action: "/admin/auth/magic-links/\(state.id)/edit/",
                submitLabel: "Edit magic link",
                removeHref: "/admin/auth/magic-links/\(state.id)/remove/",
                removeLabel: "Remove magic link"
            )
        }
        .class("cms-section")
    }
}
