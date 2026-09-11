import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SystemVariableDetails: Component {
    struct State {
        let variable: SystemVariableDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("System variable details")
            context.render(
                AdminDetailsField(label: "ID", value: state.variable.id)
            )
            context.render(
                AdminDetailsField(label: "Value", value: state.variable.value)
            )
            context.render(
                AdminDetailsField(
                    label: "Name",
                    value: state.variable.name ?? ""
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Notes",
                    value: state.variable.notes ?? ""
                )
            )
            Div {
                context.render(
                    AdminNavigationButton(
                        "Edit variable",
                        href:
                            SystemVariableRoutes.edit(
                                RouterPath(state.variable.id)
                            )
                            .description
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove variable",
                        href:
                            SystemVariableRoutes.remove(state.variable.id),
                        classes: ["danger"]
                    )
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
