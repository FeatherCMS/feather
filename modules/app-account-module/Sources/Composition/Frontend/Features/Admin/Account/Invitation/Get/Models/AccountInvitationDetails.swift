import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AccountInvitationDetails: Component {
    struct State {
        let invitation: AccountInvitationDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User invitation details")
            AdminDetailsField(label: "ID", value: state.invitation.id)
            AdminDetailsField(label: "Email", value: state.invitation.email)
            AdminDetailsField(
                label: "Roles",
                value: state.invitation.roleIds.isEmpty
                    ? "No roles assigned"
                    : state.invitation.roleIds.joined(separator: ", ")
            )
            Div {
                AdminNavigationButton(
                    "Resend invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/resend/"
                )
                AdminNavigationButton(
                    "Edit invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
