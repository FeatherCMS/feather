import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule
import NewsletterApplication

extension Subscriber.List.Controller {
    struct Default: Interface {
        let routes: Subscriber.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Subscriber.List.Interactor.Interface,
                any Subscriber.List.Presenter.Interface
            >

        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let campaignId = request.queryString("campaignId")?
                .whitespaceTrimmed
            let permissions = context.currentUserAdminListActions
            guard permissions.allows(Subscriber.Permissions.list) else {
                return try await presenter.render(
                    model: .init(
                        items: [],
                        campaigns: [],
                        search: request.querySearch() ?? "",
                        campaignId: campaignId ?? "",
                        pageState: .init(page: 1, pageSize: 20, total: 0)
                    ),
                    error: "Your account cannot access newsletter subscribers.",
                    permissions: context.currentUserPermissions
                )
            }
            do {
                return try await presenter.render(
                    model: try await interactor.list(
                        search: request.querySearch(),
                        campaignId: campaignId,
                        page: request.queryPage()
                    ),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await presenter.render(
                    model: .init(
                        items: [],
                        campaigns: [],
                        search: request.querySearch() ?? "",
                        campaignId: campaignId ?? "",
                        pageState: .init(
                            page: request.queryPage(),
                            pageSize: 20,
                            total: 0
                        )
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func viewSubscriber(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: Subscriber.Permissions.read)
            else {
                return try await presenter.renderDetailsErrorPage(
                    message: "Your account cannot view newsletter subscribers.",
                    status: .forbidden
                )
            }
            do {
                return try await presenter.renderDetailsPage(
                    item: try await interactor.get(
                        id: try context.requiredParameter("subscriberId")
                    ),
                    permissions: context.currentUserPermissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await presenter.renderDetailsErrorPage(
                    message: error.displayMessage,
                    status: error.httpStatus
                )
            }
            catch {
                return try await presenter.renderDetailsErrorPage(
                    message: error.displayMessage,
                    status: .internalServerError
                )
            }
        }
    }
}
