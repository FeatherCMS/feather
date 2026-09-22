import FeatherAdmin
import HTML
import Hummingbird
import WebComponents
import WebBuilders

struct UserIdentityAddPage: Component {
    let form: UserIdentityAddForm.State
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                NewAdminBreadcrumb(links: UserIdentityRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user identity",
                        description: "Create a user identity."
                    )
                )
            )
            context.build(
                UserIdentityAddForm(
                    state: form,
                    action: UserIdentityRoutes.add.description,
                    submitLabel: "Add identity",
                    viewHref: nil,
                    removeHref: nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
