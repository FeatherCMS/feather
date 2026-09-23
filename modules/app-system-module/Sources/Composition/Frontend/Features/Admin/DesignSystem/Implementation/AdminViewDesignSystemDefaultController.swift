import FeatherAdmin
import Hummingbird

struct AdminViewDesignSystemDefaultController: AdminViewDesignSystemController {

    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewDesignSystemInteractor,
            any AdminViewDesignSystemPresenter
        >

    func getDesignSystem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let model = try await interactor.getDesignSystem()
        return try await presenter.renderPage(model: model)
    }
}
