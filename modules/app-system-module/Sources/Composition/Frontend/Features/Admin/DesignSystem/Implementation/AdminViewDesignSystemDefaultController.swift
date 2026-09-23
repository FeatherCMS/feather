import FeatherAdmin
import Hummingbird

struct AdminViewDesignSystemDefaultController: AdminViewDesignSystemController {

    let buildRuntime:
        RuntimeBuilder<
            any AdminViewDesignSystemInteractor,
            any AdminViewDesignSystemPresenter
        >

    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let model = try await interactor.getDesignSystem()
        return try await presenter.renderPage(model: model)
    }
}
