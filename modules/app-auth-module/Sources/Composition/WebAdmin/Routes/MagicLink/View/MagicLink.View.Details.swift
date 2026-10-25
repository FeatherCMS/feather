import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension MagicLink.View {
    struct Details: WebComponents.Component {
        struct State {
            let link: Detail
            let permissions: Set<String>
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: MagicLink.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
                        title: "User magic link details",
                        description: "Inspect this sign-in magic link."
                    ),
                    fields: [
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

        private var actions: [AdminDetailView.Action] {
            var actions: [AdminDetailView.Action] = []
            if state.permissions.contains(
                MagicLink.Permissions.update.rawValue
            ) {
                actions.append(
                    .init(
                        label: "Edit magic link",
                        href: state.routes.editPath(state.link.id),
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                MagicLink.Permissions.delete.rawValue
            ) {
                actions.append(
                    .init(
                        label: "Remove magic link",
                        href: state.routes.removePath(state.link.id),
                        style: .destructive,
                        confirmationItem: state.link.credentialId
                    )
                )
            }
            return actions
        }
    }
}
