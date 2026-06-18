import HTML
import SGML
import WebStandards

struct SystemVariableDetails: Component {
    struct State {
        let variable: SystemVariableDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("System variable details")
            AdminDetailsField(label: "ID", value: state.variable.id)
            AdminDetailsField(label: "Name", value: state.variable.name)
            AdminDetailsField(label: "Value", value: state.variable.value)
            AdminDetailsField(label: "Notes", value: state.variable.notes)
            Div {
                AdminNavigationButton(
                    "Edit variable",
                    href: "/admin/system/variables/\(state.variable.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove variable",
                    href:
                        "/admin/system/variables/\(state.variable.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
