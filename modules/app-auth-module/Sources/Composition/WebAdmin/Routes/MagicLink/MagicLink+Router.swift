import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension MagicLink {
    enum Add {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
    enum Edit {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
        enum Form {}
    }
    enum List {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
    enum Remove {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
    enum View {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
}

extension MagicLink {
    struct Router {
        struct Routes {
            let list: WebRoute
            let add: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let remove: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let root = root.appending(pathComponent: "magic-links")
                list = root
                add = root.appending(pathComponent: "add")
                details = root.appending(parameter: "id")
                edit = details.appending(pathComponent: "edit")
                remove = details.appending(pathComponent: "remove")
                listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Magic links", link: root.path)
                    ]
            }

            func detailsBreadcrumb(_ id: String) -> [AdminBreadcrumb.Link] {
                breadcrumb + [
                    .init(
                        label: "Magic link",
                        link: details.path(parameter: "id", value: id)
                    )
                ]
            }

            func removeBreadcrumb(_ id: String) -> [AdminBreadcrumb.Link] {
                detailsBreadcrumb(id) + [
                    .init(
                        label: "Remove",
                        link: remove.path(parameter: "id", value: id)
                    )
                ]
            }
        }

        let routes: Routes
        private let environment: AppEnvironment
        private let renderingEngine: any RenderingEngine

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Add.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Edit.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            View.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Remove.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
