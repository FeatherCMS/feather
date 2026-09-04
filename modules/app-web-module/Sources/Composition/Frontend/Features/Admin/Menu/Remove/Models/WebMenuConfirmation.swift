import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuConfirmation: Leaf {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove menu",
                message:
                    "Are you sure you want to remove this menu? This action cannot be undone.",
                details: [
                    .init(prefix: "Name: ", value: state.source)
                ],
                submitLabel: "Remove menu",
                actionURL: "/admin/web/menus/\(state.id)/remove/",
                cancelURL: "/admin/web/menus/"
            )
        ).html()
    }
}
