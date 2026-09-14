import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationDetails: Component {
    struct State {
        let invitation: AccountInvitationDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "User invitation details",
                        description: "Review invitation status and assigned roles."
                    ),
                    fields: [
                        .init(label: "ID", value: state.invitation.id),
                        .init(label: "Email", value: state.invitation.email),
                        .init(
                            label: "Roles",
                            value: state.invitation.roleNames.isEmpty
                                ? "No roles assigned"
                                : state.invitation.roleNames.joined(separator: ", ")
                        ),
                    ],
                    actions: [
                        .init(
                            label: "Resend invitation",
                            href: "/admin/account/invitations/\(state.invitation.id)/resend/",
                            style: .secondary
                        ),
                        .init(
                            label: "Edit invitation",
                            href: "/admin/account/invitations/\(state.invitation.id)/edit/",
                            style: .primary
                        ),
                        .init(
                            label: "Remove invitation",
                            href: "/admin/account/invitations/\(state.invitation.id)/remove/",
                            style: .destructive
                        ),
                    ]
                )
            )
        }
        .class("cms-section")
    }
}
