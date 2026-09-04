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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("User invitation details")
            AdminDetailsField(label: "ID", value: state.invitation.id).html()
            AdminDetailsField(label: "Email", value: state.invitation.email).html()
            AdminDetailsField(
                label: "Roles",
                value: state.invitation.roleNames.isEmpty
                    ? "No roles assigned"
                    : state.invitation.roleNames.joined(separator: ", ")
            ).html()
            Div {
                AdminNavigationButton(
                    "Resend invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/resend/"
                ).html()
                AdminNavigationButton(
                    "Edit invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove invitation",
                    href:
                        "/admin/account/invitations/\(state.invitation.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
