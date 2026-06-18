import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorLinkConfirmation: Component {

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
        )
    }
}
