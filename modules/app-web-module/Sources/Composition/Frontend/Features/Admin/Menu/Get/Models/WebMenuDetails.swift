import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebStandards

struct WebMenuDetails: Component {
    struct State {
        let menu: WebMenuDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Menu details")
            AdminDetailsField(label: "ID", value: state.menu.id)
            AdminDetailsField(label: "Key", value: state.menu.key)
            AdminDetailsField(label: "Name", value: state.menu.name)
            AdminDetailsField(label: "Notes", value: state.menu.notes ?? "")

            Div {
                AdminNavigationButton(
                    "Edit menu",
                    href: "/admin/web/menus/\(state.menu.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove menu",
                    href: "/admin/web/menus/\(state.menu.id)/remove/",
                    classes: ["danger"]
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
