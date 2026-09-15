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

struct BlogTagConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove tag",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: "/admin/blog/tags/\(state.id)/remove/",
                cancel: "/admin/blog/tags/",
                submitLabel: "Remove tag"
            )
        )
    }
}
