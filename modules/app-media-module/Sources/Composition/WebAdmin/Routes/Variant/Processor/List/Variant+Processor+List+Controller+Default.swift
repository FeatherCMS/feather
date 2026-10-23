import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Processor.List.Controller {
    struct Default:
        Variant.Processor.List.Controller.Interface
    {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variant.Processor.List.Interactor.Interface,
                any Variant.Processor.List.Presenter.Interface
            >

        func getMediaVariantProcessors(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.list
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            do {
                return try await presenter.renderListPage(
                    variantId: try context.requiredID(),
                    model: try await interactor.list(
                        variantId: try context.requiredID(),
                        page: request.queryPage(),
                        search: request.querySearch()
                    ),
                    permissions: context.currentUserAdminListActions,
                    search: request.querySearch()
                )
            }
            catch let error as Variant.Processor.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }

        func getAddMediaVariantProcessor(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let presenter = buildRuntime(request, context).presenter
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.create
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            return try await presenter.renderAddPage(
                variantId: try context.requiredID()
            )
        }
    }
}
