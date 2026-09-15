import AuthAdminAPI
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthEmailTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let links: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]
        let identityNames: [String: String]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let userID: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "User emails",
                        description: "Manage user email addresses."
                    )
                )
            )
            context.build(AuthEmailTableContent(state: state))
        }
        .class("cms-section")
    }
}
