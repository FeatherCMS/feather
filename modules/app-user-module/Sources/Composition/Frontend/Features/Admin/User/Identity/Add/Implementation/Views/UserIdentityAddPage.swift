import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct UserIdentityAddPage: Component {
    let form: UserIdentityForm.State
    let nonceToken: String?

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(links: UserIdentityRoutes.breadcrumb))
            context.render(NewAdminPageHeader(state: .init(
                title: "Add user identity",
                description: "Create a user identity."
            )))
            context.render(UserIdentityForm(
                state: form,
                action: UserIdentityRoutes.add.description,
                submitLabel: "Add identity",
                viewHref: nil,
                removeHref: nil,
                nonceToken: nonceToken
            ))
        }
        .class("cms-section")
    }
}
