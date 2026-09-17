import FeatherAdmin
import FeatherValidation
import Hummingbird
import MediaContracts

struct AdminAddMediaVariantDefaultController: AdminAddMediaVariantController {
    let buildRuntime: @Sendable (Request, DefaultRequestContext) -> (
        interactor: any AdminAddMediaVariantInteractor,
        presenter: any AdminAddMediaVariantPresenter
    )

    func getAddMediaVariant(request: Request, context: DefaultRequestContext) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.create) else {
            return try await runtime.presenter.renderAddError(input: nil, error: .forbidden)
        }
        return try await runtime.presenter.renderAddPage(state: .empty())
    }

    func postAddMediaVariant(request: Request, context: DefaultRequestContext) async throws -> Response {
        let runtime = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.create) else {
            return try await runtime.presenter.renderAddError(input: nil, error: .forbidden)
                .response(from: request, context: context)
        }
        var input: MediaVariantFormInput?
        do {
            let payload = try await request.decode(as: NonceRequest<MediaVariantFormInput>.self, context: context)
            input = payload.input
            guard await AdminNonceStore.shared.consume(payload.nonce, sessionToken: context.sessionToken) else {
                return Response(status: .badRequest)
            }
            try await payload.input.validate()
            try await runtime.interactor.add(input: payload.input)
            return runtime.presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return try await runtime.presenter.renderValidationError(input: input, error: error)
                .response(from: request, context: context)
        }
        catch let error as AdminAddMediaVariantError {
            return try await runtime.presenter.renderAddError(input: input, error: error)
                .response(from: request, context: context)
        }
    }
}
