import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
import Hummingbird
import RedirectModule
import RedirectApplication

extension RedirectModule.Rule.List.Controller {
    struct Default: Interface {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any RedirectModule.Rule.List.Interactor.Interface,
            any RedirectModule.Rule.List.Presenter.Interface
        >

    func getRedirectRules(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectModule.Rule.Permissions.list)
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }

        let search = request.querySearch()
        let rawStatusCode = request.queryString("statusCode")?
            .whitespaceTrimmed
        let statusCode = rawStatusCode.flatMap(Int.init)
            .flatMap(RedirectModule.Rule.StatusCode.init(rawValue:))
        do {
            let model = try await interactor.listRedirectRules(
                page: request.queryPage(),
                search: search,
                statusCode: statusCode
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: context.currentUserAdminListActions,
                search: search,
                statusCode: rawStatusCode
            )
        }
        catch let error as RedirectModule.Rule.List.Error {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
}
