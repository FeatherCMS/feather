import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebDomain
import WebModule

extension MenuItem.Edit {
    struct Page: WebComponents.Component {

        struct State {
            let menuId: String
            let id: String
            let form: MenuItem.Form.Component.State
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
                                "Update the navigation menu configuration."
                        )
                    )
                )
                context.build(
                    MenuItem.TabBar(
                        active: .items,
                        detailsPath: state.routes.menu.editPath(state.menuId),
                        itemsPath: state.routes.itemsPath(state.menuId)
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Edit item",
                            description: "Update the navigation menu link."
                        )
                    ) {
                        context.build(
                            MenuItem.Form.Component(
                                state: state.form,
                                action: state.routes.itemEditPath(
                                    menuID: state.menuId,
                                    itemID: state.id
                                ),
                                submitLabel: "Edit item",
                                removeHref:
                                    state.routes.itemRemovePath(
                                        menuID: state.menuId,
                                        itemID: state.id,
                                        origin: .edit
                                    ),
                                removeLabel: "Remove item"
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
