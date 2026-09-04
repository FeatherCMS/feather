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

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Menu details")
            AdminDetailsField(label: "ID", value: state.menu.id).renderHTML()
            AdminDetailsField(label: "Key", value: state.menu.key).renderHTML()
            AdminDetailsField(label: "Name", value: state.menu.name).renderHTML()
            AdminDetailsField(label: "Notes", value: state.menu.notes ?? "").renderHTML()

            Div {
                AdminNavigationButton(
                    "Edit menu",
                    href: "/admin/web/menus/\(state.menu.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove menu",
                    href: "/admin/web/menus/\(state.menu.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
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
