import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebComponents

extension Role.Detail {
    struct Details: Component {
        let routes: Role.Router.Routes
        let role: Role.Detail.RepositoryModel
        let permissions: AdminListActions

        func html(context: inout BuilderContext) -> Section {
            var actions: [AdminDetailView.Action] = []
            if permissions.allows(Role.Permissions.update) {
                actions.append(
                    .init(
                        label: "Edit",
                        href: routes.editPath(role.id),
                        style: .primary
                    )
                )
            }
            if permissions.allows(Role.Permissions.delete) {
                actions.append(
                    .init(
                        label: "Remove",
                        href: routes.removePath(role.id)
                            .description,
                        style: .destructive
                    )
                )
            }
            return context.build(
                AdminDetailView(
                    breadcrumb: routes.breadcrumb,
                    pageHeader: .primary(
                        title: "User role details",
                        description: "Inspect this user role."
                    ),
                    fields: [
                        .init(label: "Key", value: role.key),
                        .init(
                            label: "Name",
                            value: role.name.emptyToNil ?? "—"
                        ),
                        .init(
                            label: "Notes",
                            value: role.notes.emptyToNil ?? "—"
                        ),
                    ],
                    actions: actions
                )
            )
        }
    }
}
