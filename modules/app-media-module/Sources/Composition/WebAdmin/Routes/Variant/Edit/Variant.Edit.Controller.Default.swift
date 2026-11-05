import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Edit.Controller {
    struct Default: Interface {
        let routes: Variant.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variant.Edit.Interactor.Interface,
                any Variant.Edit.Presenter.Interface
            >

        func getEditMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Variant.Permissions.update)
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
                                routes.editPath(detail.id)
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
            catch let error as Variant.Edit.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
                    .response(from: request, context: context)
            }
        }

        func postEditMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Variant.Permissions.update)
            else {
                return try await runtime.presenter
                    .renderErrorPage(error: .forbidden)
                    .response(from: request, context: context)
            }
            let id = try context.requiredID()
            var input: Variant.Form.Input?
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Variant.Form.Input>.self,
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
                try await runtime.interactor.update(
                    id: id,
                    input: payload.input
                )
                return runtime.presenter.renderSuccess(id: id)
            }
            catch let error as ValidationError {
                let detail = try await runtime.interactor.load(id: id)
                var state = Variant.Form.State.from(input: input)
                var errors: [String: String] = [:]
                for failure in error.failures {
                    precondition(
                        errors.updateValue(failure.message, forKey: failure.key)
                            == nil
                    )
                }
                state.apply(
                    errors: errors
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
            catch let error as Variant.Edit.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
                    .response(from: request, context: context)
            }
        }

        func getEditMediaVariantProcessor(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.update
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
            catch let error as Variant.Edit.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
                    .response(from: request, context: context)
            }
        }

        func postAddMediaVariantProcessor(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.create
                )
            else { return Response(status: .forbidden) }
            let id = try context.requiredID()
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Variant.Processor.Form.Input>.self,
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
                return AdminNotification.redirect(
                    to: routes.processorPath(id),
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
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.update
                )
            else { return Response(status: .forbidden) }
            let id = try context.requiredID()
            let processorId = try context.requiredParameter("processorId")
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Variant.Processor.Form.Input>.self,
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
                return AdminNotification.redirect(
                    to: routes.processorPath(id),
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
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: Variant.Processor.Permissions.delete
                )
            else { return Response(status: .forbidden) }
            let id = try context.requiredID()
            do {
                let payload = try await request.decode(
                    as: NonceRequest<AdminListRemoveFormInput>.self,
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
                return AdminNotification.redirect(
                    to: routes.processorPath(id),
                    notification: .init(title: "Removed", message: message)
                )
            }
            catch {
                return try await runtime.presenter
                    .renderErrorPage(error: map(error))
                    .response(from: request, context: context)
            }
        }

        private func map(_ error: any Error) -> Variant.Edit.Error {
            if let error = error as? Variant.Edit.Error { return error }
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
}
