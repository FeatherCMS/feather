import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct UserRoleDetails: Component {
    struct State {
        let role: UserRoleDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("User role details")
            context.render(AdminDetailsField(label: "ID", value: state.role.id))
            context.render(
                AdminDetailsField(label: "Name", value: state.role.name)
            )
            context.render(
                AdminDetailsField(label: "Notes", value: state.role.notes)
            )
            Div {
                context.render(
                    AdminNavigationButton(
                        "Edit role",
                        href: "/admin/user/roles/\(state.role.id)/edit/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove role",
                        href: "/admin/user/roles/\(state.role.id)/remove/",
                        classes: ["danger"]
                    )
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
