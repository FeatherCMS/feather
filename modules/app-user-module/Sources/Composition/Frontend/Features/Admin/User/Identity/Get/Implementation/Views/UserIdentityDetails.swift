import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityDetails: Component {
    let identity: AdminGetUserIdentityModel
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if permissions.allows(UserPermissions.Identities.update) {
            actions.append(.init(
                label: "Edit",
                href: UserIdentityRoutes.edit(RouterPath(identity.id)).description,
                style: .primary
            ))
        }
        if permissions.allows(UserPermissions.Identities.delete) {
            actions.append(.init(
                label: "Remove",
                href: UserIdentityRoutes.remove(RouterPath(identity.id)).description,
                style: .destructive
            ))
        }
        return context.render(NewAdminDetailView(
            breadcrumb: UserIdentityRoutes.breadcrumb,
            pageHeader: .init(
                title: "User identity details",
                description: "Inspect this user identity."
            ),
            fields: [
                .init(label: "ID", value: identity.id),
                .init(label: "Status", value: identity.status.emptyToNil ?? "—"),
                .init(
                    label: "Roles",
                    value: identity.roleNames.isEmpty ? "—" : identity.roleNames.joined(separator: ", ")
                ),
            ],
            actions: actions
        ))
    }
}
