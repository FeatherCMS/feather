import FeatherAdmin
import HTML
import Hummingbird
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleEditPage: Component {
    let id: String
    let form: UserRoleEditForm.State
    let permissions: AdminListActions
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(AdminBreadcrumb(links: UserRoleRoutes.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit user role",
                        description: "Update this user role."
                    )
                )
            )
            context.build(
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
