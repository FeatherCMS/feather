import HTML
import SGML
import WebStandards

struct UserRoleDetails: Component {
    struct State {
        let role: UserRoleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User role details")
            AdminDetailsField(label: "ID", value: state.role.id)
            AdminDetailsField(label: "Name", value: state.role.name)
            AdminDetailsField(label: "Notes", value: state.role.notes)
            Div {
                AdminNavigationButton(
                    "Edit role",
                    href: "/admin/user/roles/\(state.role.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove role",
                    href: "/admin/user/roles/\(state.role.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
