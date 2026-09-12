import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemJobTable: Component {
    struct State {
        let jobs: [Components.Schemas.SystemJobSchema]
        let permissions: NewAdminListActions
        let pageState: NewAdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: SystemJobRoutes.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Worker jobs",
                        description: "Inspect jobs processed by the workers."
                    )
                )
            )
            context.render(
                SystemJobTableContent(
                    jobs: state.jobs,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
