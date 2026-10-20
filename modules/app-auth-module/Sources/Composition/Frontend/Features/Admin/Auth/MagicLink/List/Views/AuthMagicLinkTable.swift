import AuthAdminAPI
import FeatherWebAdmin
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
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "User magic links",
                        description: "Manage sign-in magic links."
                    )
                )
            )
            context.build(AuthMagicLinkTableContent(state: state))
        }
        .class("cms-section")
    }
}
