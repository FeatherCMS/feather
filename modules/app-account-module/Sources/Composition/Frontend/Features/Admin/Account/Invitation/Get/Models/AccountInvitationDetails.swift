import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationDetails: Component {
    struct State {
        let invitation: AccountInvitationDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("User invitation details")
            context.render(
                AdminDetailsField(label: "ID", value: state.invitation.id)
            )
            context.render(
                AdminDetailsField(label: "Email", value: state.invitation.email)
            )
            context.render(
                AdminDetailsField(
                    label: "Roles",
                    value: state.invitation.roleNames.isEmpty
                        ? "No roles assigned"
                        : state.invitation.roleNames.joined(separator: ", ")
                )
            )
            Div {
                context.render(
                    AdminNavigationButton(
                        "Resend invitation",
                        href:
                            "/admin/account/invitations/\(state.invitation.id)/resend/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Edit invitation",
                        href:
                            "/admin/account/invitations/\(state.invitation.id)/edit/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove invitation",
                        href:
                            "/admin/account/invitations/\(state.invitation.id)/remove/",
                        classes: ["danger"]
                    )
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
