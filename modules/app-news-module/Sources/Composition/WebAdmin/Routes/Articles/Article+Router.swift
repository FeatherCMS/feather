import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article {
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
                        .init(label: "Articles", link: list.path)
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
            let buildAddRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Article.Add.Interactor.Interface,
                        any Article.Add.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Article.Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Article.Add.Interactor.Interface,
                            any Article.Add.Presenter.Interface
                        >(
                            interactor: Article.Add.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Article.Presenter.Default(
                                request: request,
                                context: context,
                                mediaAPI: api.mediaAdminAPI(),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildDetailRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Article.Detail.Interactor.Interface,
                        any Article.Detail.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Article.Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Article.Detail.Interactor.Interface,
                            any Article.Detail.Presenter.Interface
                        >(
                            interactor: Article.Detail.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Article.Presenter.Default(
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
                        any Article.Edit.Interactor.Interface,
                        any Article.Edit.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Article.Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Article.Edit.Interactor.Interface,
                            any Article.Edit.Presenter.Interface
                        >(
                            interactor: Article.Edit.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Article.Presenter.Default(
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
                        any Article.Remove.Interactor.Interface,
                        any Article.Remove.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Article.Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Article.Remove.Interactor.Interface,
                            any Article.Remove.Presenter.Interface
                        >(
                            interactor: Article.Remove.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Article.Presenter.Default(
                                request: request,
                                context: context,
                                mediaAPI: api.mediaAdminAPI(),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            Article.List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            let addController = Article.Add.Controller.Default(
                routes: routes,
                buildRuntime: buildAddRuntime
            )
            router.get(
                routes.add.routerPath,
                use: addController.getAddNewsArticle
            )
            router.post(
                routes.add.routerPath,
                use: addController.postAddNewsArticle
            )
            let viewController = Article.Detail.Controller.Default(
                buildRuntime: buildDetailRuntime
            )
            router.get(
                routes.details.routerPath,
                use: viewController.getNewsArticle
            )
            let editController = Article.Edit.Controller.Default(
                routes: routes,
                buildRuntime: buildEditRuntime
            )
            router.get(
                routes.edit.routerPath,
                use: editController.getEditNewsArticle
            )
            router.post(
                routes.edit.routerPath,
                use: editController.postEditNewsArticle
            )
            let removeController = Article.Remove.Controller.Default(
                buildRuntime: buildRemoveRuntime
            )
            router.get(
                routes.remove.routerPath,
                use: removeController.getRemoveNewsArticle
            )
            router.post(
                routes.remove.routerPath,
                use: removeController.postRemoveNewsArticle
            )
        }
    }
}
