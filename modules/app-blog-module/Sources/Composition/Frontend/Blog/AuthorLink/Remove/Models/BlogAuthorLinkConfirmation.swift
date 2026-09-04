import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct BlogAuthorLinkConfirmation: Leaf {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove blog author link",
                message:
                    "Are you sure you want to remove this blog author link? This action cannot be undone.",
                details: [
                    .init(prefix: "Label: ", value: state.label)
                ],
                submitLabel: "Remove link",
                actionURL:
                    "/admin/blog/authors/\(state.menuId)/links/\(state.id)/remove/",
                cancelURL: "/admin/blog/authors/\(state.menuId)/links/"
            )
        ).renderHTML()
    }
}
