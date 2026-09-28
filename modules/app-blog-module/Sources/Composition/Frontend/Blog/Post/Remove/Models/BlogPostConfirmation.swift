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
        let nonceToken: String
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove post",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: "/admin/blog/posts/\(state.id)/remove/",
                submit: .init(label: "Remove post", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
}
