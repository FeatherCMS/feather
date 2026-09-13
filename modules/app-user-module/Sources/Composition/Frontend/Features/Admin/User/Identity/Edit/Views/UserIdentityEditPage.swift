import FeatherAdmin
import HTML
import Hummingbird
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityEditPage: Component {
    let id: String
    let form: UserIdentityEditForm.State
    let permissions: NewAdminListActions
    let nonceToken: String?

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: UserIdentityRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit user identity",
                        description: "Update this user identity."
                    )
                )
            )
            context.render(
                UserIdentityEditForm(
                    state: form,
                    action: UserIdentityRoutes.edit(RouterPath(id)).description,
                    submitLabel: "Save changes",
                    viewHref: UserIdentityRoutes.details(RouterPath(id))
                        .description,
                    removeHref: permissions.allows(
                        UserPermissions.Identities.delete
                    )
                        ? UserIdentityRoutes.remove(RouterPath(id)).description
                        : nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
