import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension Email.View {
    struct Details: WebComponents.Component {
        struct State {
            let link: Detail
            let permissions: Set<String>
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Email.Router.Routes
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
                        .init(label: "Email", value: state.link.email),
                        .init(
                            label: "Identity ID",
                            value: state.link.identityId
                        )
                    ],
                    actions: actions
                )
            )
        }

        private var actions: [AdminDetailView.Action] {
            var actions: [AdminDetailView.Action] = []
            if state.permissions.contains(
                Email.Permissions.update.rawValue
            ) {
                actions.append(
                    .init(
                        label: "Edit email",
                        href: state.routes.editPath(state.link.id),
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                Email.Permissions.delete.rawValue
            ) {
                actions.append(
                    .init(
                        label: "Remove email",
                        href: state.routes.removePath(state.link.id),
                        style: .destructive,
                        confirmationItem: state.link.email
                    )
                )
            }
            return actions
        }
    }
}
