import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemContracts
import WebBuilders
import WebComponents

struct SystemVariableDetails: Component {
    struct State {
        let variable: SystemVariableDetailsModel
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminDetailView(
                breadcrumb: SystemVariableRoutes.breadcrumb,
                pageHeader: .init(
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
    ) -> [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if state.permissions.allows(SystemPermissions.Variables.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        SystemVariableRoutes.edit(
                            RouterPath(state.variable.id)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.allows(SystemPermissions.Variables.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href: NewAdminLocation.remove(
                        path: SystemVariableRoutes.remove.description,
                        ids: [state.variable.id],
                        returnTo:
                            SystemVariableRoutes.details(
                                RouterPath(state.variable.id)
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
