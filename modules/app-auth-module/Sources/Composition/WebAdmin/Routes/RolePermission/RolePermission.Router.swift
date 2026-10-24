import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension RolePermission {


    struct Router {
        struct Routes {
            let edit: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                edit = root.appending(pathComponent: "access-control")
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Access Control", link: edit.path)
                    ]
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            RolePermission.Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .controller.route(on: router, routes: routes)
        }
    }
}
