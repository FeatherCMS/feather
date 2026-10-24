import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Search.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Page.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Page.Search.Interactor.Interface,
                any Page.Search.Presenter.Interface
            >

        func getSearchPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Page.Permissions.list
            )
            let emptyModel = Page.Search.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )
            let model: Page.Search.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.searchPages(
                        page: page,
                        search: search
                    )
                    error = nil
                }
                catch let caughtError {
                    model = emptyModel
                    error = caughtError.displayMessage
                }
            }
            else {
                model = emptyModel
                error = nil
            }
            return try await presenter.renderSearchPage(
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }
        func postPageStatus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let id = try context.requiredID()
            let payload = try await request.decode(
                as: AdminStatusActionFormInput.self,
                context: context
            )
            let repository = Page.Metadata.Repository.OpenAPI(
                api: API.Client(
                    environment: environment,
                    requestContext: context
                )
            )
            let metadata = try await repository.load(id: id)
            let targetStatus = resolvedStatus(
                from: payload,
                current: metadata
            )
            try await WebModule.Metadata
                .StatusUpdater(
                    api: API.Client(
                        environment: environment,
                        requestContext: context
                    )
                )
                .update(
                    referenceType: "web.page",
                    referenceID: id,
                    status: targetStatus
                )
            return AdminNotificationFlash.redirect(
                to: payload.normalizedReturnTo ?? routes.list.path,
                notification: statusNotification(for: targetStatus)
            )
        }

        private func resolvedStatus(
            from payload: AdminStatusActionFormInput,
            current metadata: AdminMetadataFormValue
        ) -> String {
            let allowedStatuses = Set(["draft", "published", "archived"])
            let selectedStatus = payload.normalizedStatus
            return allowedStatuses.contains(selectedStatus)
                ? selectedStatus
                : metadata.normalizedStatus
        }

        private func statusNotification(
            for status: String
        ) -> AdminNotification.State {
            switch status {
            case "published":
                return .init(
                    title: "Published",
                    message: "Web page published successfully."
                )
            case "archived":
                return .init(
                    title: "Archived",
                    message: "Web page archived successfully."
                )
            default:
                return .init(
                    title: "Draft",
                    message: "Web page moved to draft successfully."
                )
            }
        }
    }
}
