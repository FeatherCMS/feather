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

struct BlogTagConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        return context.render(AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove tag",
                message:
                    "Are you sure you want to remove this tag? This action cannot be undone.",
                details: [
                    .init(prefix: "Title: ", value: state.source)
                ],
                submitLabel: "Remove tag",
                actionURL: "/admin/blog/tags/\(state.id)/remove/",
                cancelURL: "/admin/blog/tags/"
            )
        ))
    }
}
