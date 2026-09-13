import AuthAdminAPI
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthCredentialTable: Component {
    struct State {
        let canAccess: Bool
        let permissions: Set<String>
        let credentials:
            [AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "User credentials",
                        description: "Manage user credentials."
                    )
                )
            )
            context.render(AuthCredentialTableContent(state: state))
        }
        .class("cms-section")
    }
}
