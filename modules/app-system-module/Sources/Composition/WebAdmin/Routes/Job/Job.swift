import FeatherAdmin
import FeatherModuleKit
import Foundation
import Hummingbird
import SystemModule

enum Job {
    
    struct Router {
        struct Routes {
            let list: WebRoute
            let details: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let list = root.appending(pathComponent: "jobs")
                self.list = list
                self.details = list.appending(parameter: "id")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Worker jobs", link: list.path)
                    ]
            }

            func detailsPath(_ id: String) -> String {
                details.path(parameter: "id", value: id)
            }

            func listURL(
                page: Int? = nil,
                search: String? = nil,
                status: Int? = nil
            ) -> String {
                var query: [String] = []
                if let page, page > 1 {
                    query.append("page=\(page)")
                }
                if let search = search?.emptyToNil {
                    query.append(
                        "search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? search)"
                    )
                }
                if let status {
                    query.append("status=\(status)")
                }
                let path = list.path
                return query.isEmpty
                    ? path : "\(path)?\(query.joined(separator: "&"))"
            }
        }

        let routes: Routes
        private let apiBuilder: API.Builder
        private let renderingEngine: any RenderingEngine

        init(
            apiBuilder: API.Builder,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.apiBuilder = apiBuilder
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            View.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
