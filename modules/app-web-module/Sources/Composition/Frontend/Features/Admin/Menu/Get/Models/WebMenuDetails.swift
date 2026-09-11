import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuDetails: Component {
    struct State {
        let menu: WebMenuDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Menu details")
            context.render(AdminDetailsField(label: "ID", value: state.menu.id))
            context.render(
                AdminDetailsField(label: "Key", value: state.menu.key)
            )
            context.render(
                AdminDetailsField(label: "Name", value: state.menu.name)
            )
            context.render(
                AdminDetailsField(label: "Notes", value: state.menu.notes ?? "")
            )

            Div {
                context.render(
                    AdminNavigationButton(
                        "Edit menu",
                        href: "/admin/web/menus/\(state.menu.id)/edit/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove menu",
                        href: "/admin/web/menus/\(state.menu.id)/remove/",
                        classes: ["danger"]
                    )
                )
            }
            .class(
                "button-row",
                "web-menu-details-actions",
                "admin-detail-actions"
            )
        }
        .class("cms-section")
    }
}
