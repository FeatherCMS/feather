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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("User role details")
            AdminDetailsField(label: "ID", value: state.role.id).html()
            AdminDetailsField(label: "Name", value: state.role.name).html()
            AdminDetailsField(label: "Notes", value: state.role.notes).html()
            Div {
                AdminNavigationButton(
                    "Edit role",
                    href: "/admin/user/roles/\(state.role.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove role",
                    href: "/admin/user/roles/\(state.role.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
