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

struct BlogAuthorLinkConfirmation: Component {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove blog author link",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.label],
                action:
                    "/admin/blog/authors/\(state.menuId)/links/\(state.id)/remove/",
                submit: .init(label: "Remove link", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
}
