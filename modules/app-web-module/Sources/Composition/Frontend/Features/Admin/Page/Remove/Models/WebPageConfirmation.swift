import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebPageConfirmation: Component {

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
                title: "Remove page",
                message:
                    "Are you sure you want to remove this page? This action cannot be undone.",
                details: [
                    .init(prefix: "Title: ", value: state.source)
                ],
                submitLabel: "Remove page",
                actionURL: "/admin/web/pages/\(state.id)/remove/",
                cancelURL: "/admin/web/pages/"
            )
        ))
    }
}
