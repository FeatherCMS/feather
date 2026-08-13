import FeatherAdmin
import Hummingbird

struct AppPublicContentDefaultPresenter: AppPublicContentPresenter {
    let themeRenderer: any PublicThemeRenderer

    func render(
        content: AppPublicResolvedContent,
        request: Request
    ) async -> HTMLResponse {
        let moduleContext = content.moduleContext
        return themeRenderer.render(
            templateIdentifier: moduleContext.templateIdentifier,
            context: moduleContext.payload
        )
    }
}
