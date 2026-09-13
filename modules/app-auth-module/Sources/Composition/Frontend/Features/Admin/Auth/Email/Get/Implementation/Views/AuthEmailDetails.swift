import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AuthEmailDetails: Component {
    struct State {
        let link: AuthEmailDetailsModel
        let permissions: Set<String>
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> Section {
        context.render(
            NewAdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "User email details",
                    description: "Inspect this user email."
                ),
                fields: [
                    .init(label: "ID", value: state.link.id),
                    .init(label: "Identity ID", value: state.link.identityId),
                ],
                actions: actions
            )
        )
    }

    private var actions: [NewAdminDetailView.Action] {
        var actions: [NewAdminDetailView.Action] = []
        if state.permissions.contains(AuthPermissions.Emails.update.rawValue) {
            actions.append(
                .init(
                    label: "Edit email",
                    href: "/admin/auth/emails/\(state.link.id)/edit/",
                    style: .primary
                )
            )
        }
        if state.permissions.contains(AuthPermissions.Emails.delete.rawValue) {
            actions.append(
                .init(
                    label: "Remove email",
                    href: "/admin/auth/emails/\(state.link.id)/remove/",
                    style: .destructive
                )
            )
        }
        return actions
    }
}
