import FeatherAdmin
import FeatherValidation
import Hummingbird
import MediaAdminAPI
import MediaContracts

struct AdminEditMediaVariantDefaultController: AdminEditMediaVariantController {
    let buildRuntime: RuntimeBuilder<
        any AdminEditMediaVariantInteractor,
        any AdminEditMediaVariantPresenter
    >

    func getEditMediaVariant(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.update)
        else {
            return try await runtime.presenter
                .renderErrorPage(error: .forbidden)
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        do {
            let detail = try await runtime.interactor.load(id: id)
            guard detail.id == id else {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location:
                            MediaVariantRoutes.edit(
                                RouterPath(detail.id)
                            )
                            .description
                    ]
                )
            }
            return try await runtime.presenter
                .renderEditPage(
                    id: detail.id,
                    detail: detail,
                    state: .from(detail: detail),
                    permissions: context.currentUserAdminListActions
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditMediaVariantError {
            return try await runtime.presenter.renderErrorPage(error: error)
                .response(from: request, context: context)
        }
    }

    func postEditMediaVariant(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.update)
        else {
            return try await runtime.presenter
                .renderErrorPage(error: .forbidden)
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        var input: MediaVariantFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<MediaVariantFormInput>.self,
                context: context
            )
            input = payload.input
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await payload.input.validate()
            try await runtime.interactor.update(id: id, input: payload.input)
            return runtime.presenter.renderSuccess(id: id)
        }
        catch let error as ValidationError {
            let detail = try await runtime.interactor.load(id: id)
            var state = MediaVariantFormView.State.from(input: input)
            state.apply(
                errors: Dictionary(
                    uniqueKeysWithValues: error.failures.map {
                        ($0.key, $0.message)
                    }
                )
            )
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    detail: detail,
                    state: state,
                    permissions: context.currentUserAdminListActions
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditMediaVariantError {
            return try await runtime.presenter.renderErrorPage(error: error)
                .response(from: request, context: context)
        }
    }

    func getEditMediaVariantProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.update
            )
        else {
            return try await runtime.presenter
                .renderErrorPage(error: .forbidden)
                .response(from: request, context: context)
        }
        let variantId = try context.requiredID()
        let processorId = try context.requiredParameter("processorId")
        do {
            let processor = try await runtime.interactor.loadProcessor(
                variantId: variantId,
                id: processorId
            )
            return try await runtime.presenter
                .renderProcessorEditPage(
                    variantId: variantId,
                    processor: processor,
                    permissions: context.currentUserAdminListActions
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditMediaVariantError {
            return try await runtime.presenter.renderErrorPage(error: error)
                .response(from: request, context: context)
        }
    }

    func getRemoveMediaVariantProcessors(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.delete
            )
        else {
            return try await runtime.presenter
                .renderErrorPage(error: .forbidden)
                .response(from: request, context: context)
        }
        let variantId = try context.requiredID()
        let ids = request.queryStrings("ids")
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location:
                        MediaVariantRoutes.processors(RouterPath(variantId))
                        .description
                ]
            )
        }
        do {
            return try await runtime.presenter
                .renderProcessorRemovePage(
                    variantId: variantId,
                    items: try await runtime.interactor.processorNames(
                        variantId: variantId,
                        ids: ids
                    ),
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditMediaVariantError {
            return try await runtime.presenter.renderErrorPage(error: error)
                .response(from: request, context: context)
        }
    }

    func postAddMediaVariantProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.create
            )
        else { return Response(status: .forbidden) }
        let id = try context.requiredID()
        do {
            let payload = try await request.decode(
                as: NonceRequest<MediaVariantProcessorFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await payload.input.validate()
            try await runtime.interactor.addProcessor(
                variantId: id,
                input: payload.input
            )
            return AdminNotificationFlash.redirect(
                to: MediaVariantRoutes.processors(RouterPath(id)).description,
                notification: .init(
                    title: "Added",
                    message: "Processor added successfully."
                )
            )
        }
        catch {
            return try await runtime.presenter
                .renderErrorPage(error: map(error))
                .response(from: request, context: context)
        }
    }

    func postEditMediaVariantProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.update
            )
        else { return Response(status: .forbidden) }
        let id = try context.requiredID()
        let processorId = try context.requiredParameter("processorId")
        do {
            let payload = try await request.decode(
                as: NonceRequest<MediaVariantProcessorFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await payload.input.validate()
            try await runtime.interactor.updateProcessor(
                variantId: id,
                id: processorId,
                input: payload.input
            )
            return AdminNotificationFlash.redirect(
                to: MediaVariantRoutes.processors(RouterPath(id)).description,
                notification: .init(
                    title: "Saved",
                    message: "Processor saved successfully."
                )
            )
        }
        catch {
            return try await runtime.presenter
                .renderErrorPage(error: map(error))
                .response(from: request, context: context)
        }
    }

    func postRemoveMediaVariantProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.delete
            )
        else { return Response(status: .forbidden) }
        let id = try context.requiredID()
        do {
            let payload = try await request.decode(
                as: NonceRequest<NewAdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            let processorIds = payload.input.normalizedIds
            guard !processorIds.isEmpty else {
                return Response(status: .badRequest)
            }
            for processorId in processorIds {
                try await runtime.interactor.removeProcessor(
                    variantId: id,
                    id: processorId
                )
            }
            let message =
                processorIds.count == 1
                ? "Processor removed successfully."
                : "\(processorIds.count) processors removed successfully."
            return AdminNotificationFlash.redirect(
                to: MediaVariantRoutes.processors(RouterPath(id)).description,
                notification: .init(title: "Removed", message: message)
            )
        }
        catch {
            return try await runtime.presenter
                .renderErrorPage(error: map(error))
                .response(from: request, context: context)
        }
    }

    private func map(_ error: Error) -> AdminEditMediaVariantError {
        if let error = error as? AdminEditMediaVariantError { return error }
        if let error = error as? ValidationError {
            _ = error
            return .unavailable
        }
        if let error = error as? OpenAPIRepositoryError {
            switch error {
            case .notFound: return .notFound
            case .unauthorized: return .unauthorized
            case .forbidden: return .forbidden
            case .conflict: return .conflict
            case .failure(let failure) where failure.statusCode == 409:
                return .conflict
            case .failure, .transport: return .unavailable
            }
        }
        return .unavailable
    }
}
