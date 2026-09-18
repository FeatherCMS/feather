import FeatherAdmin
import FeatherValidation
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
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit menu",
                        description: "Update the navigation menu configuration."
                    )
                )
            )
            context.build(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.build(
                WebMenuItemGroup {
                    context.build(
                        NewAdminPageHeader(
                            state: .init(
                                title: "Edit item",
                                description:
                                    "Update the navigation menu link.",
                                level: 2,
                                showSeparator: true
                            )
                        )
                    )
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
