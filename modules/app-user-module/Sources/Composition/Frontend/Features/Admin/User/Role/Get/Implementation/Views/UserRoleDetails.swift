import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleDetails: Component {
    let role: UserRoleDetailsModel
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if permissions.allows(UserPermissions.Roles.update) {
            actions.append(.init(
                label: "Edit",
                href: UserRoleRoutes.edit(RouterPath(role.id)).description,
                style: .primary
            ))
        }
        if permissions.allows(UserPermissions.Roles.delete) {
            actions.append(.init(
                label: "Remove",
                href: UserRoleRoutes.remove(RouterPath(role.id)).description,
                style: .destructive
            ))
        }
        return context.render(NewAdminDetailView(
            breadcrumb: UserRoleRoutes.breadcrumb,
            pageHeader: .init(
                title: "User role details",
                description: "Inspect this user role."
            ),
            fields: [
                .init(label: "ID", value: role.id),
                .init(label: "Name", value: role.name.emptyToNil ?? "—"),
                .init(label: "Notes", value: role.notes.emptyToNil ?? "—"),
            ],
            actions: actions
        ))
    }
}
