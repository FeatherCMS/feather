import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AuthEmailDetails: Component {
    struct State {
        let link: AuthEmailDetailsModel
        let permissions: Set<String>
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            AdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .primary(
                    title: "User email details",
                    description: "Inspect this user email."
                ),
                fields: [
                    .init(label: "Identity ID", value: state.link.identityId)
                ],
                actions: actions
            )
        )
    }

    private var actions: [AdminDetailView.Action] {
        var actions: [AdminDetailView.Action] = []
        if state.permissions.contains(
            AuthEmail.Permissions.update.rawValue
        ) {
            actions.append(
                .init(
                    label: "Edit email",
                    href: "/admin/auth/emails/\(state.link.id)/edit/",
                    style: .primary
                )
            )
        }
        if state.permissions.contains(
            AuthEmail.Permissions.delete.rawValue
        ) {
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
