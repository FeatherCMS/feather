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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("System permission details")
            AdminDetailsField(label: "ID", value: state.permission.id).html()
            AdminDetailsField(label: "Name", value: state.permission.name ?? "").html()
            AdminDetailsField(
                label: "Notes",
                value: state.permission.notes ?? ""
            ).html()
            Div {
                AdminNavigationButton(
                    "Edit permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove permission",
                    href:
                        "/admin/system/permissions/\(state.permission.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
