import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Permission.View {
    struct Page: Component {
        struct State {
            let permission: Result
            let permissions: AdminListActions
            let routes: Permission.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminDetailView(
                    breadcrumb: state.routes.breadcrumb,
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
                            state.routes.editPath(state.permission.id),
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
                            path: state.routes.remove.path,
                            ids: [state.permission.id],
                            returnTo:
                                state.routes.detailsPath(state.permission.id)
                        ),
                        style: .destructive
                    )
                )
            }
            return result
        }
    }
}
