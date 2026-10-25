import AccountModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Invitation.Detail {
    struct Page: Component {
        let routes: Invitation.Router.Routes
        struct State {
            let invitation: Result
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
                            .init(
                                label: "Email",
                                value: state.invitation.email
                            ),
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
                                href: routes.invitationResendPath(
                                    state.invitation.id
                                ),
                                style: .secondary
                            ),
                            .init(
                                label: "Edit invitation",
                                href: routes.invitationEditPath(
                                    state.invitation.id
                                ),
                                style: .primary
                            ),
                            .init(
                                label: "Remove invitation",
                                href: routes.invitationRemovePath(
                                    state.invitation.id
                                ),
                                style: .destructive
                            ),
                        ]
                    )
                )
            }
            .class("cms-section")
        }
    }
}
