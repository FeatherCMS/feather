import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Menu.Edit {
    struct Page: WebComponents.Component {

        struct State {
            let id: String
            let form: WebModule.Menu.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: MenuItem.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit menu",
                            description:
                                "Update the navigation menu configuration.",
                            moreActions: [
                                .init(
                                    label: "Remove menu",
                                    href: state.routes.menu.detailsRemovePath(
                                        state.id
                                    ),
                                    style: .destructive
                                )
                            ]
                        )
                    )
                )
                context.build(
                    MenuItem.TabBar(
                        active: .details,
                        detailsPath: state.routes.menu.editPath(state.id),
                        itemsPath: state.routes.itemsPath(state.id)
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Menu details",
                            description:
                                "Update the navigation menu configuration."
                        )
                    ) {
                        context.build(
                            Menu.Form.Component(
                                state: state.form,
                                action: state.routes.menu.editPath(state.id),
                                submitLabel: "Edit menu",
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
