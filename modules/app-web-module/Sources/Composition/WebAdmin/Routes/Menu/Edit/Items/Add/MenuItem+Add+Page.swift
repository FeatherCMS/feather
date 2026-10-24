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

extension MenuItem.Add {
    struct Page: WebComponents.Component {

        struct State {
            let menuId: String
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
                            title: "Add item",
                            description: "Add a link to the navigation menu."
                        )
                    ) {
                        context.build(
                            MenuItem.Form.Component(
                                state: state.form,
                                action: state.routes.itemsAddPath(state.menuId),
                                submitLabel: "Add item"
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
