import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuItemConfirmation: Component {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove item",
                message:
                    "Are you sure you want to remove this item? This action cannot be undone.",
                details: [
                    .init(prefix: "Label: ", value: state.label)
                ],
                submitLabel: "Remove item",
                actionURL:
                    "/admin/web/menus/\(state.menuId)/items/\(state.id)/remove/",
                cancelURL: "/admin/web/menus/\(state.menuId)/items/"
            )
        )
    }
}
