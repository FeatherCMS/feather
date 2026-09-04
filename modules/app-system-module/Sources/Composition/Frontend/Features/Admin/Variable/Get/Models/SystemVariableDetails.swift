import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct SystemVariableDetails: Leaf {
    struct State {
        let variable: SystemVariableDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("System variable details")
            AdminDetailsField(label: "ID", value: state.variable.id).renderHTML()
            AdminDetailsField(label: "Value", value: state.variable.value).renderHTML()
            AdminDetailsField(label: "Name", value: state.variable.name ?? "").renderHTML()
            AdminDetailsField(label: "Notes", value: state.variable.notes ?? "").renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit variable",
                    href: "/admin/system/variables/\(state.variable.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove variable",
                    href:
                        "/admin/system/variables/\(state.variable.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
