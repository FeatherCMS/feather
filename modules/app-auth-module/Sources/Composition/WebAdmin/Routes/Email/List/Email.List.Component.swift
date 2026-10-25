import AuthAdminAPI
import AuthModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Email.List {
    struct Component: WebComponents.Component {
        struct State {
            let isAdded: Bool
            let isEdited: Bool
            let isRemoved: Bool
            let canAccess: Bool
            let permissions: Set<String>
            let canAdd: Bool
            let links:
                [AuthAdminAPI.Components.Schemas.AuthEmailQuerySchemasItem]
            let identityNames: [String: String]
            let page: Int
            let pageSize: Int
            let total: Int
            let search: String
            let userID: String?
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Email.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "User emails",
                            description: "Manage user email addresses."
                        )
                    )
                )
                context.build(TableContent(state: state))
            }
            .class("cms-section")
        }
    }
}
