import FeatherAdmin
import Hummingbird
import HTML
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuDetails: Component {
    struct State {
        let menu: WebMenuDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: Set<String>
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Menu details",
                        description: "Review the navigation menu configuration."
                    ),
                    fields: [
                        .init(label: "ID", value: state.menu.id),
                        .init(label: "Key", value: state.menu.key),
                        .init(label: "Name", value: state.menu.name),
                        .init(label: "Notes", value: state.menu.notes ?? "—"),
                    ],
                    actions: [
                        .init(
                            label: "Edit menu",
                            href: WebMenuRoutes.edit(RouterPath(state.menu.id)).description,
                            style: .primary
                        ),
                        .init(
                            label: "Remove menu",
                            href: WebMenuRoutes.details(RouterPath(state.menu.id)).appendingPath(RouterPath("remove")).description,
                            style: .destructive
                        ),
                    ]
                )
            )
        }
        .class("cms-section")
    }
}
