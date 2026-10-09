import FeatherAdmin
import Hummingbird

struct AdminNewsArticleFormRenderer {
    func render(
        input: AdminNewsArticleFormInput,
        runtime: AdminNewsArticleRuntime,
        error: String?,
        title: String,
        action: String,
        submitLabel: String,
        removeHref: String?
    ) async throws -> HTMLResponse {
        let categories = (try? await runtime.interactor.categories()) ?? []
        return try await runtime.presenter.renderForm(
            input: input,
            categories: categories,
            error: error,
            title: title,
            action: action,
            submitLabel: submitLabel,
            removeHref: removeHref
        )
    }
}
