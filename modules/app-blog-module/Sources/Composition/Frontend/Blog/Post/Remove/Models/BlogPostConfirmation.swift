import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogPostConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove post",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: "/admin/blog/posts/\(state.id)/remove/",
                cancel: "/admin/blog/posts/",
                submitLabel: "Remove post"
            )
        )
    }
}
