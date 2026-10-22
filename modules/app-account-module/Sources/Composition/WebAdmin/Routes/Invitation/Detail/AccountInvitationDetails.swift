import AccountModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationDetails: Component {
    let routes: Invitation.Router.Routes
    struct State {
        let invitation: AccountInvitationDetailsModel
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
                        title: "User invitation details",
                        description:
                            "Review invitation status and assigned roles."
                    ),
                    fields: [
                        .init(label: "Email", value: state.invitation.email),
                        .init(
                            label: "Roles",
                            value: state.invitation.roleNames.isEmpty
                                ? "No roles assigned"
                                : state.invitation.roleNames.joined(
                                    separator: ", "
                                )
                        ),
                    ],
                    actions: [
                        .init(
                            label: "Resend invitation",
                            href: routes.invitationResend(state.invitation.id),
                            style: .secondary
                        ),
                        .init(
                            label: "Edit invitation",
                            href: routes.invitationEdit(state.invitation.id),
                            style: .primary
                        ),
                        .init(
                            label: "Remove invitation",
                            href: routes.invitationRemove(state.invitation.id),
                            style: .destructive
                        ),
                    ]
                )
            )
        }
        .class("cms-section")
    }
}
