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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("System variable details")
            AdminDetailsField(label: "ID", value: state.variable.id).html()
            AdminDetailsField(label: "Value", value: state.variable.value).html()
            AdminDetailsField(label: "Name", value: state.variable.name ?? "").html()
            AdminDetailsField(label: "Notes", value: state.variable.notes ?? "").html()
            Div {
                AdminNavigationButton(
                    "Edit variable",
                    href: "/admin/system/variables/\(state.variable.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove variable",
                    href:
                        "/admin/system/variables/\(state.variable.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
