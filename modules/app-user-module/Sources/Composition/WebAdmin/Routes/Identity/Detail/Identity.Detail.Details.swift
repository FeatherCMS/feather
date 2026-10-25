import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebBuilders
import WebComponents

extension Identity.Detail {
    struct Details: Component {
        let routes: Identity.Router.Routes
        let identity: Model
        let permissions: AdminListActions

        func html(context: inout BuilderContext) -> Section {
            let statusChip = Identity.StatusChip.make(status: identity.status)
            var actions: [AdminDetailView.Action] = []
            if permissions.allows(Identity.Permissions.update) {
                actions.append(
                    .init(
                        label: "Edit",
                        href: routes.editPath(identity.id)
                            .description,
                        style: .primary
                    )
                )
            }
            if permissions.allows(Identity.Permissions.delete) {
                actions.append(
                    .init(
                        label: "Remove",
                        href: routes.removePath(identity.id)
                            .description,
                        style: .destructive
                    )
                )
            }
            return context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb,
                    pageHeader: .primary(
                        title: "User identity details",
                        description: "Inspect this user identity."
                    ),
                    fields: [
                        .init(label: "ID", value: identity.id),
                        .init(label: "Name", value: identity.name),
                        .init(
                            label: "Status",
                            chip: .init(
                                label: statusChip.label,
                                color: statusChip.color
                            )
                        ),
                        .init(
                            label: "Roles",
                            value: identity.roleNames.isEmpty
                                ? "—"
                                : identity.roleNames.joined(separator: ", ")
                        ),
                    ],
                    actions: actions
                )
            )
        }
    }
}
