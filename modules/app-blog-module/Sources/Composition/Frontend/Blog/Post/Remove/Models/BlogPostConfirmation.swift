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

struct BlogPostConfirmation: Leaf {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove post",
                message:
                    "Are you sure you want to remove this post? This action cannot be undone.",
                details: [
                    .init(prefix: "Title: ", value: state.source)
                ],
                submitLabel: "Remove post",
                actionURL: "/admin/blog/posts/\(state.id)/remove/",
                cancelURL: "/admin/blog/posts/"
            )
        ).renderHTML()
    }
}
