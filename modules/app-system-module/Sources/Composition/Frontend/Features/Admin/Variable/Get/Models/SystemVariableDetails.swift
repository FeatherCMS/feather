import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

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
            context.render(AdminDetailsField(label: "ID", value: state.variable.id))
            context.render(AdminDetailsField(label: "Value", value: state.variable.value))
            context.render(AdminDetailsField(label: "Name", value: state.variable.name ?? ""))
            context.render(AdminDetailsField(label: "Notes", value: state.variable.notes ?? ""))
            Div {
                context.render(AdminNavigationButton(
                    "Edit variable",
                    href: "/admin/system/variables/\(state.variable.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove variable",
                    href:
                        "/admin/system/variables/\(state.variable.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
