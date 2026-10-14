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
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "User credentials",
                        description: "Manage user credentials."
                    )
                )
            )
            context.build(AuthCredentialTableContent(state: state))
        }
        .class("cms-section")
    }
}
