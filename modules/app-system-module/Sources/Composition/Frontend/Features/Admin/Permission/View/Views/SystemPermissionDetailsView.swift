import SystemModule
import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionDetailsView: Component {
    struct State {
        let permission: SystemPermissionDetailsModel
        let permissions: AdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminDetailView(
                breadcrumb: SystemPermissionRoutes.breadcrumb,
                pageHeader: .primary(
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

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
        if state.permissions.allows(
            SystemModule.Permission.Permissions.update
        ) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        SystemPermissionRoutes.edit(
                            RouterPath(state.permission.key)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.allows(
            SystemModule.Permission.Permissions.delete
        ) {
            result.append(
                .init(
                    label: "Remove",
                    href: AdminLocation.remove(
                        path: SystemPermissionRoutes.remove.description,
                        ids: [state.permission.id],
                        returnTo:
                            SystemPermissionRoutes.details(
                                RouterPath(state.permission.key)
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
