import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationDetails: Leaf {
    struct State {
        let invitation: AccountInvitationDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("User invitation details")
            AdminDetailsField(label: "ID", value: state.invitation.id).renderHTML()
            AdminDetailsField(label: "Email", value: state.invitation.email).renderHTML()
            AdminDetailsField(
                label: "Roles",
                value: state.invitation.roleNames.isEmpty
                    ? "No roles assigned"
                    : state.invitation.roleNames.joined(separator: ", ")
            ).renderHTML()
            Div {
                AdminNavigationButton(
                    "Resend invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/resend/"
                ).renderHTML()
                AdminNavigationButton(
                    "Edit invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
