import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

struct MenuDetails: Component {
    struct State {
        let menu: MenuDetailsModel
        let breadcrumb: [AdminBreadcrumb.Link]
        let permissions: Set<String>
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
                        title: "Menu details",
                        description: "Review the navigation menu configuration."
                    ),
                    fields: [
                        .init(label: "Key", value: state.menu.key),
                        .init(label: "Name", value: state.menu.name),
                        .init(label: "Notes", value: state.menu.notes ?? "—"),
                    ],
                    actions: [
                        .init(
                            label: "Edit menu",
                            href: MenuRoutes.edit(RouterPath(state.menu.id))
                                .description,
                            style: .primary
                        ),
                        .init(
                            label: "Remove menu",
                            href:
                                MenuRoutes.details(RouterPath(state.menu.id))
                                .appendingPath(RouterPath("remove"))
                                .description,
                            style: .destructive
                        ),
                    ]
                )
            )
        }
        .class("cms-section")
    }
}
