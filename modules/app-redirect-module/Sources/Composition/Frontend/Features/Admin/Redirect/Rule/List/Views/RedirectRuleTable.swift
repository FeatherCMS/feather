import FeatherAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let rules:
            [RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
        let statusCode: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: RedirectRuleRoutes.redirectBreadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
}
