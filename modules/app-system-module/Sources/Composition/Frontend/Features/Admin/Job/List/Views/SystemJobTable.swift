import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemJobTable: Component {
    struct State {
        let jobs: [Components.Schemas.SystemJobSchema]
        let permissions: NewAdminListActions
        let pageState: NewAdminListPageState
        let search: String?
        let status: Int?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemJobRoutes.listBreadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Worker jobs",
                        description: "Inspect jobs processed by the workers."
                    )
                )
            )
            context.build(
                SystemJobTableContent(
                    jobs: state.jobs,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search,
                    status: state.status
                )
            )
        }
        .class("cms-section")
    }
}
