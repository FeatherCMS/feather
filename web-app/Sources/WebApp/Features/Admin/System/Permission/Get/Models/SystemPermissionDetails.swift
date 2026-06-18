import HTML
import SGML
import WebStandards

struct SystemPermissionDetails: Component {
    struct State {
        let permission: SystemPermissionDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("System permission details")
            AdminDetailsField(label: "ID", value: state.permission.id)
            AdminDetailsField(label: "Name", value: state.permission.name)
            AdminDetailsField(label: "Notes", value: state.permission.notes)
            Div {
                AdminNavigationButton(
                    "Edit permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
