import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserIdentityAdd: Component {

    struct State {
        let form: UserIdentityForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add identity")

            context.render(
                UserIdentityForm(
                    state: state.form,
                    action: "/admin/user/identities/add/",
                    submitLabel: "Add identity"
                )
            )
        }
        .class("cms-section")
    }
}
