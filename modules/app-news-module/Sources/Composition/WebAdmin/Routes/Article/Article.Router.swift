import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import MediaWebAdmin
import MediaModule
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
            let mediaAssetList: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                mediaAssetList: WebRoute
            ) {
                let list = root
                self.list = list
                self.add = list.appending(pathComponent: "add")
                self.details = list.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.remove = details.appending(pathComponent: "remove")
                self.mediaAssetList = mediaAssetList
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Articles", link: list.path)
                    ]
            }

            func imagePickerPath(_ field: String) -> String {
                var components = URLComponents()
                components.path = mediaAssetList.path
                components.queryItems = [
                    URLQueryItem(name: "picker", value: "1"),
                    URLQueryItem(name: "field", value: field),
                    URLQueryItem(
                        name: "extensions",
                        value: AllowedExtensions.images.queryValue
                    ),
                ]
                return components.string ?? components.path
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
                        any Add.Interactor.Interface,
                        any Add.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Add.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Add.Interactor.Interface,
                            any Add.Presenter.Interface
                        >(
                            interactor: Add.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Add.Presenter.Default(
                                request: request,
                                context: context,
                                mediaRepository: MediaModule.Asset.File.View
                                    .Repository.OpenAPI(api: api.mediaAdminAPI()),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildDetailRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Detail.Interactor.Interface,
                        any Detail.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Detail.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Detail.Interactor.Interface,
                            any Detail.Presenter.Interface
                        >(
                            interactor: Detail.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Detail.Presenter.Default(
                                request: request,
                                context: context,
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildEditRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Edit.Interactor.Interface,
                        any Edit.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Edit.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Edit.Interactor.Interface,
                            any Edit.Presenter.Interface
                        >(
                            interactor: Edit.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Edit.Presenter.Default(
                                request: request,
                                context: context,
                                mediaRepository: MediaModule.Asset.File.View
                                    .Repository.OpenAPI(api: api.mediaAdminAPI()),
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            let buildRemoveRuntime:
                @Sendable (Request, AuthenticatedRequestContext) ->
                    WebAdminRuntime<
                        any Remove.Interactor.Interface,
                        any Remove.Presenter.Interface
                    > = {
                        request,
                        context in
                        let api = API.Client(
                            environment: environment,
                            requestContext: context
                        )
                        let repository = Remove.Repository.OpenAPI(
                            api: api
                        )
                        return WebAdminRuntime<
                            any Remove.Interactor.Interface,
                            any Remove.Presenter.Interface
                        >(
                            interactor: Remove.Interactor.Default(
                                repository: repository
                            ),
                            presenter: Remove.Presenter.Default(
                                request: request,
                                context: context,
                                renderingEngine: renderingEngine,
                                routes: routes
                            )
                        )
                    }
            List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            let addController = Add.Controller.Default(
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
            let viewController = Detail.Controller.Default(
                buildRuntime: buildDetailRuntime
            )
            router.get(
                routes.details.routerPath,
                use: viewController.getNewsArticle
            )
            let editController = Edit.Controller.Default(
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
            let removeController = Remove.Controller.Default(
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
