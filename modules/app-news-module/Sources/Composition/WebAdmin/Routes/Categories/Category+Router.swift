import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category {
    struct Router: Sendable {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let remove: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let list = root
                self.list = list
                self.add = list.appending(pathComponent: "add")
                self.details = list.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.remove = details.appending(pathComponent: "remove")
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Categories", link: list.path)
                    ]
            }

            func detailsPath(_ id: String) -> String {
                details.path(parameter: "id", value: id)
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func removePath(_ id: String) -> String {
                remove.path(parameter: "id", value: id)
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            let buildDetailRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Category.Detail.Interactor.Interface,
                        any Category.Detail.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Category.Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Category.Detail.Interactor.Interface,
                            any Category.Detail.Presenter.Interface
                        >(
                            interactor: Category.Detail.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Category.Detail.Presenter.Default(
                                request: request,
                                context: context,
                                mediaAPI: api.mediaAdminAPI(),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildEditRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Category.Edit.Interactor.Interface,
                        any Category.Edit.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Category.Edit.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Category.Edit.Interactor.Interface,
                            any Category.Edit.Presenter.Interface
                        >(
                            interactor: Category.Edit.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Category.Edit.Presenter.Default(
                                request: request,
                                context: context,
                                mediaAPI: api.mediaAdminAPI(),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildRemoveRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Category.Remove.Interactor.Interface,
                        any Category.Remove.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Category.Remove.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Category.Remove.Interactor.Interface,
                            any Category.Remove.Presenter.Interface
                        >(
                            interactor: Category.Remove.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Category.Remove.Presenter.Default(
                                request: request,
                                context: context,
                                mediaAPI: api.mediaAdminAPI(),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            Category.List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Category.Add
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            let detailController = Category.Detail.Controller.Default(
                buildRuntime: buildDetailRuntime
            )
            router.get(
                routes.details.routerPath,
                use: detailController.getNewsCategory
            )
            let editController = Category.Edit.Controller.Default(
                routes: routes,
                buildRuntime: buildEditRuntime
            )
            router.get(
                routes.edit.routerPath,
                use: editController.getEditNewsCategory
            )
            router.post(
                routes.edit.routerPath,
                use: editController.postEditNewsCategory
            )
            let removeController = Category.Remove.Controller.Default(
                buildRuntime: buildRemoveRuntime
            )
            router.get(
                routes.remove.routerPath,
                use: removeController.getRemoveNewsCategory
            )
            router.post(
                routes.remove.routerPath,
                use: removeController.postRemoveNewsCategory
            )
        }
    }
}
