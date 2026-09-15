import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AuthMagicLinkDetails: Component {
    struct State {
        let link: AuthMagicLinkDetailsModel
        let permissions: Set<String>
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "User magic link details",
                    description: "Inspect this sign-in magic link."
                ),
                fields: [
                    .init(label: "ID", value: state.link.id),
                    .init(
                        label: "Credential ID",
                        value: state.link.credentialId
                    ),
                    .init(
                        label: "Persistent",
                        value: state.link.isPersistent ? "Yes" : "No"
                    ),
                ],
                actions: actions
            )
        )
    }

    private var actions: [NewAdminDetailView.Action] {
        var actions: [NewAdminDetailView.Action] = []
        if state.permissions.contains(
            AuthPermissions.MagicLinks.update.rawValue
        ) {
            actions.append(
                .init(
                    label: "Edit magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/edit/",
                    style: .primary
                )
            )
        }
        if state.permissions.contains(
            AuthPermissions.MagicLinks.delete.rawValue
        ) {
            actions.append(
                .init(
                    label: "Remove magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/remove/",
                    style: .destructive
                )
            )
        }
        return actions
    }
}
