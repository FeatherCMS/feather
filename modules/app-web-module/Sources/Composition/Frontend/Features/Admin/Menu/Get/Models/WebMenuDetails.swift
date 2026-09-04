import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuDetails: Leaf {
    struct State {
        let menu: WebMenuDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Menu details")
            AdminDetailsField(label: "ID", value: state.menu.id).html()
            AdminDetailsField(label: "Key", value: state.menu.key).html()
            AdminDetailsField(label: "Name", value: state.menu.name).html()
            AdminDetailsField(label: "Notes", value: state.menu.notes ?? "").html()

            Div {
                AdminNavigationButton(
                    "Edit menu",
                    href: "/admin/web/menus/\(state.menu.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove menu",
                    href: "/admin/web/menus/\(state.menu.id)/remove/",
                    classes: ["danger"]
                ).html()
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
