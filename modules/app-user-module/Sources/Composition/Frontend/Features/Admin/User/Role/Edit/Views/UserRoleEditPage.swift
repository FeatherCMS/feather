import FeatherAdmin
import HTML
import Hummingbird
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleEditPage: Component {
    let id: String
    let form: UserRoleEditForm.State
    let permissions: NewAdminListActions
    let nonceToken: String?

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(links: UserRoleRoutes.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit user role",
                        description: "Update this user role."
                    )
                )
            )
            context.render(
                UserRoleEditForm(
                    state: form,
                    action: UserRoleRoutes.edit(RouterPath(id)).description,
                    submitLabel: "Save changes",
                    viewHref: UserRoleRoutes.details(RouterPath(id))
                        .description,
                    removeHref: permissions.allows(UserPermissions.Roles.delete)
                        ? UserRoleRoutes.remove(RouterPath(id)).description
                        : nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
