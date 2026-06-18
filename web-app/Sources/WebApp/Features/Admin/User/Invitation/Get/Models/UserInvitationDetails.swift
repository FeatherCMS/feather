import HTML
import SGML
import WebStandards

struct UserInvitationDetails: Component {
    struct State {
        let invitation: UserInvitationDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User invitation details")
            AdminDetailsField(label: "ID", value: state.invitation.id)
            AdminDetailsField(label: "Email", value: state.invitation.email)
            Div {
                AdminNavigationButton(
                    "Edit invitation",
                    href: "/admin/user/invitations/\(state.invitation.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove invitation",
                    href:
                        "/admin/user/invitations/\(state.invitation.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
