import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemEdit: Component {

    struct State {
        let menuId: String
        let id: String
        let form: WebMenuItemForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit menu",
                        description: "Update the navigation menu configuration."
                    )
                )
            )
            context.build(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Edit item",
                        description: "Update the navigation menu link."
                    )
                ) {
                    context.build(
                        WebMenuItemForm(
                            state: state.form,
                            action:
                                WebMenuItemRoutes.edit(
                                    RouterPath(state.menuId),
                                    RouterPath(state.id)
                                )
                                .description,
                            submitLabel: "Edit item",
                            removeHref:
                                WebMenuItemRoutes.itemRemove(
                                    RouterPath(state.menuId),
                                    RouterPath(state.id),
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
