import FeatherAdmin
import Hummingbird

struct AdminGetDesignSystemDefaultController: AdminGetDesignSystemController {

    let buildRuntime: @Sendable (Request, DefaultRequestContext) -> (
        interactor: any AdminGetDesignSystemInteractor,
        presenter: any AdminGetDesignSystemPresenter
    )

    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getDesignSystem()
        return try await presenter.renderPage(model: model)
    }
}
