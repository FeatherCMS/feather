import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

struct SystemJobTable: Component {
    struct State {
        let jobs: [Components.Schemas.SystemJobSchema]
        let permissions: AdminListActions
        let pageState: AdminListPageState
        let search: String?
        let status: Int?
        let routes: WebAdmin.System.Job.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(
                    links: state.routes.listBreadcrumb
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
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
                    status: state.status,
                    routes: state.routes
                )
            )
        }
        .class("cms-section")
    }
}
