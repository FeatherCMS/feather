import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct UserIdentityEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        var form: UserIdentityForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit identity")
            if state.isEdited {
                P("User identity edited successfully.").class("success")
            }
            context.render(UserIdentityForm(
                state: state.form,
                action: "/admin/user/identities/\(state.id)/edit/",
                submitLabel: "Edit identity",
                removeHref: "/admin/user/identities/\(state.id)/remove/",
                removeLabel: "Remove identity"
            ))
        }
        .class("cms-section")
    }
}
