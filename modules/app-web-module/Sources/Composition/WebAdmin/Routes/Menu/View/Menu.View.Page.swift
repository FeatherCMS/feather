import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Menu.View {
    struct Page: WebComponents.Component {
        struct State {
            let menu: WebModule.Menu.View.Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let permissions: Set<String>
            let routes: WebModule.Menu.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminDetailView(
                        breadcrumb: state.breadcrumb,
                        pageHeader: .primary(
                            title: "Menu details",
                            description:
                                "Review the navigation menu configuration."
                        ),
                        fields: [
                            .init(label: "Key", value: state.menu.key),
                            .init(label: "Name", value: state.menu.name),
                            .init(
                                label: "Notes",
                                value: state.menu.notes ?? "—"
                            ),
                        ],
                        actions: [
                            .init(
                                label: "Edit menu",
                                href: state.routes.editPath(state.menu.id),
                                style: .primary
                            ),
                            .init(
                                label: "Remove menu",
                                href: state.routes.detailsRemovePath(
                                    state.menu.id
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
