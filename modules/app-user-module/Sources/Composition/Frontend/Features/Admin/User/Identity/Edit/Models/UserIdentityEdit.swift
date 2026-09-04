import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct UserIdentityEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        var form: UserIdentityForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit identity")
            if state.isEdited {
                P("User identity edited successfully.").class("success")
            }
            UserIdentityForm(
                state: state.form,
                action: "/admin/user/identities/\(state.id)/edit/",
                submitLabel: "Edit identity",
                removeHref: "/admin/user/identities/\(state.id)/remove/",
                removeLabel: "Remove identity"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
