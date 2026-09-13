import AuthAdminAPI
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthMagicLinkTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let links: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema]
        let emailByAuthEmailId: [String: String]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let userID: String?
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "User magic links",
                        description: "Manage sign-in magic links."
                    )
                )
            )
            context.render(AuthMagicLinkTableContent(state: state))
        }
        .class("cms-section")
    }
}
