import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminListWebPageDefaultController:
    AdminListWebPageController
{
    let environment: AppEnvironment
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListWebPageInteractor,
            any AdminListWebPagePresenter
        >

    func getWebPages(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebModule.Permissions.Pages.list
        )
        let emptyModel = AdminListWebPageModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebPageModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listWebPages(
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
        return try await presenter.renderListPage(
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
    func postWebPageStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListWebPageFormOpenAPIRepository(
            api: API.Client(environment: environment, requestContext: context)
        )
        let metadata = try await repository.load(id: id)
        let targetStatus = resolvedStatus(
            from: payload,
            current: metadata
        )
        try await AdminWebMetadataStatusUpdater(
            api: API.Client(environment: environment, requestContext: context)
        )
        .update(
            referenceType: "web.page",
            referenceID: id,
            status: targetStatus
        )
        return AdminNotificationFlash.redirect(
            to: payload.normalizedReturnTo ?? WebPageRoutes.list.description,
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
