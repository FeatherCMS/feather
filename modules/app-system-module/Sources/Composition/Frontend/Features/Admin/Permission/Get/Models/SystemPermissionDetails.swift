import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct SystemPermissionDetails: Leaf {
    struct State {
        let permission: SystemPermissionDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("System permission details")
            AdminDetailsField(label: "ID", value: state.permission.id).renderHTML()
            AdminDetailsField(label: "Name", value: state.permission.name ?? "").renderHTML()
            AdminDetailsField(
                label: "Notes",
                value: state.permission.notes ?? ""
            ).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
