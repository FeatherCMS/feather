import Foundation
import Hummingbird

struct AdminAddMediaFolderDefaultController: AdminAddMediaFolderController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddMediaFolderInteractor,
            presenter: any AdminAddMediaFolderPresenter
        )

    func getAddMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
        let view = request.queryString("view") ?? "grid"
        let model = try await interactor.getAddMediaFolder(
            parentId: parentId,
            view: view
        )
        return presenter.renderPage(
            model: model,
            permissions: context.currentUserPermissions
        )
    }

    func postAddMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: MediaFolderAddForm.self,
            context: context
        )
        let model = try await interactor.postAddMediaFolder(payload: payload)
        if model.error == nil {
            var queryItems: [URLQueryItem] = []
            if let parentId = model.parentId {
                queryItems.append(.init(name: "parent_id", value: parentId))
            }
            if model.view != "grid" {
                queryItems.append(.init(name: "view", value: model.view))
            }
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/assets/",
                        title: "Added",
                        message: "Item added successfully.",
                        extraQueryItems: queryItems
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
