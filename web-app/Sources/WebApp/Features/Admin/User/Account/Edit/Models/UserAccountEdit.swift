import HTML
import SGML
import WebStandards

struct UserAccountEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        var form: UserAccountForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit account")
            if state.isEdited {
                P("User account edited successfully.").class("success")
            }
            UserAccountForm(
                state: state.form,
                action: "/admin/user/accounts/\(state.id)/edit/",
                submitLabel: "Edit account",
                removeHref: "/admin/user/accounts/\(state.id)/remove/",
                removeLabel: "Remove account"
            )
        }
        .class("cms-section")
    }
}
