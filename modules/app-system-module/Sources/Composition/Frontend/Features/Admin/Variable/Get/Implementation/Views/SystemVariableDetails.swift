import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SystemVariableDetails: Component {
    struct State {
        let variable: SystemVariableDetailsModel
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminDetailView(
                breadcrumb: SystemVariableRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Variable details",
                    description: "System variable details."
                ),
                fields: [
                    .init(label: "ID", value: state.variable.id),
                    .init(label: "Name", value: state.variable.name ?? "—"),
                    .init(label: "Value", value: state.variable.value),
                    .init(label: "Notes", value: state.variable.notes ?? "—"),
                ],
                actions: [
                    .init(
                        label: "Edit",
                        href:
                            SystemVariableRoutes.edit(
                                RouterPath(state.variable.id)
                            )
                            .description,
                        style: .primary
                    ),
                    .init(
                        label: "Remove",
                        href: SystemVariableRoutes.removeFromDetails(
                            state.variable.id
                        ),
                        style: .destructive
                    ),
                ]
            )
        )
    }
}
