import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemContracts
import WebBuilders
import WebComponents

struct SystemPermissionDetailsView: Component {
    struct State {
        let permission: SystemPermissionDetailsModel
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminDetailView(
                breadcrumb: SystemPermissionRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Permission details",
                    description: "System permission details."
                ),
                fields: [
                    .init(label: "Key", value: state.permission.key),
                    .init(
                        label: "Name",
                        value: state.permission.name?.emptyToNil ?? "—"
                    ),
                    .init(
                        label: "Notes",
                        value: state.permission.notes?.emptyToNil ?? "—"
                    ),
                ],
                actions: actions
            )
        )
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if state.permissions.allows(SystemPermissions.Permissions.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        SystemPermissionRoutes.edit(
                            RouterPath(state.permission.id)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.allows(SystemPermissions.Permissions.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href: NewAdminLocation.remove(
                        path: SystemPermissionRoutes.remove.description,
                        ids: [state.permission.id],
                        returnTo:
                            SystemPermissionRoutes.details(
                                RouterPath(state.permission.id)
                            )
                            .description
                    ),
                    style: .destructive
                )
            )
        }
        return result
    }
}
