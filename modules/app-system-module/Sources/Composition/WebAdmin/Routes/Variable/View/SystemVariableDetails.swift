import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemModule
import WebBuilders
import WebComponents

struct SystemVariableDetails: Component {
    struct State {
        let variable: SystemVariableDetailsModel
        let permissions: AdminListActions
        let routes: Variable.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminDetailView(
                breadcrumb: state.routes.breadcrumb,
                pageHeader: .primary(
                    title: "Variable details",
                    description: "System variable details."
                ),
                fields: [
                    .init(label: "Key", value: state.variable.key),
                    .init(
                        label: "Value",
                        value: state.variable.value.isEmpty
                            ? "—"
                            : state.variable.value
                    ),
                    .init(label: "Name", value: state.variable.name ?? "—"),
                    .init(label: "Notes", value: state.variable.notes ?? "—"),
                ],
                actions: actions(state: state)
            )
        )
    }

    private func actions(
        state: State
    ) -> [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
        if state.permissions.allows(SystemModule.Variable.Permissions.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        state.routes.editPath(state.variable.key),
                    style: .primary
                )
            )
        }
        if state.permissions.allows(SystemModule.Variable.Permissions.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href: AdminLocation.remove(
                        path: state.routes.remove.path,
                        ids: [state.variable.id],
                        returnTo:
                            state.routes.detailsPath(state.variable.key)
                    ),
                    style: .destructive
                )
            )
        }
        return result
    }
}
