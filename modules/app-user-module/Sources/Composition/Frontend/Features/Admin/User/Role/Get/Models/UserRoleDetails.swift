import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct UserRoleDetails: Leaf {
    struct State {
        let role: UserRoleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("User role details")
            AdminDetailsField(label: "ID", value: state.role.id).renderHTML()
            AdminDetailsField(label: "Name", value: state.role.name).renderHTML()
            AdminDetailsField(label: "Notes", value: state.role.notes).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit role",
                    href: "/admin/user/roles/\(state.role.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove role",
                    href: "/admin/user/roles/\(state.role.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
