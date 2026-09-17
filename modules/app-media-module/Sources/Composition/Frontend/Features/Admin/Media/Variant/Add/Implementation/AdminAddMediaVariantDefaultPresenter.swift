import FeatherAdmin
import FeatherValidation
import Hummingbird
import MediaContracts
import WebComponents

struct AdminAddMediaVariantDefaultPresenter: AdminAddMediaVariantPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(state: MediaVariantFormView.State) async throws
        -> HTMLResponse
    {
        let nonce = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: MediaVariantAddPage(
                form: MediaVariantFormView(
                    state: state,
                    action: MediaVariantRoutes.add.description,
                    submitLabel: "Add variant",
                    nonceToken: nonce
                )
            )
        )
    }

    func renderValidationError(
        input: MediaVariantFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state = MediaVariantFormView.State.from(input: input)
        state.apply(
            errors: Dictionary(
                uniqueKeysWithValues: error.failures.map {
                    ($0.key, $0.message)
                }
            )
        )
        return try await renderAddPage(state: state)
    }

    func renderAddError(
        input: MediaVariantFormInput?,
        error: AdminAddMediaVariantError
    ) async throws -> HTMLResponse {
        switch error {
        case .forbidden:
            return try await status(
                title: "Forbidden",
                message: "Your account cannot create media variants.",
                status: .forbidden
            )
        case .unauthorized:
            return try await status(
                title: "Session expired",
                message: "Please sign in again to create media variants.",
                status: .unauthorized
            )
        case .conflict:
            var state = MediaVariantFormView.State.from(input: input)
            state.apply(error: "A media variant with this key already exists.")
            let page = try await renderAddPage(state: state)
            return HTMLResponse(content: page.content, status: .conflict)
        case .unavailable:
            var state = MediaVariantFormView.State.from(input: input)
            state.apply(
                error:
                    "The media variant could not be created. Please try again."
            )
            let page = try await renderAddPage(state: state)
            return HTMLResponse(
                content: page.content,
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: MediaVariantRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "Media variant added successfully."
            )
        )
    }

    private func renderPage<T: Component>(
        content: T,
        status: HTTPResponse.Status = .ok
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media variants",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func status(
        title: String,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            ),
            status: status
        )
    }
}
