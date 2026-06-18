import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove author",
                message:
                    "Are you sure you want to remove this author? This action cannot be undone.",
                details: [
                    .init(prefix: "Name: ", value: state.source)
                ],
                submitLabel: "Remove author",
                actionURL: "/admin/blog/authors/\(state.id)/remove/",
                cancelURL: "/admin/blog/authors/"
            )
        )
    }
}
