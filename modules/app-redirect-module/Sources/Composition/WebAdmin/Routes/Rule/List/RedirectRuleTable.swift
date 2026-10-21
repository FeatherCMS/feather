import RedirectModule
import FeatherWebAdmin
import HTML
import RedirectAdminAPI
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleTable: Component {
    struct State {
        let permissions: AdminListActions
        let rules:
            [RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let statusCode: String?
        let routes: RedirectModule.Rule.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: state.routes.redirectBreadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Redirect rules",
                        description:
                            "Manage paths that redirect to other destinations."
                    )
                )
            )
            context.build(RedirectRuleTableContent(state: state))
        }
        .class("cms-section")
    }
