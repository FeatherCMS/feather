import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetDefaultController: AdminRemoveMediaAssetController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveMediaAssetInteractor,
            any AdminRemoveMediaAssetPresenter
        >

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Assets.delete)
        else { return Response(status: .forbidden) }
        let payload = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(status: .badRequest)
        }
        let ids = payload.input.normalizedIds
        let location = AdminLocation.removeCancel(
            path: MediaAssetRoutes.list.description,
            returnTo: payload.input.normalizedReturnTo
        )
        guard !ids.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        do {
            try await interactor.remove(ids: ids)
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: ids.count == 1
                        ? "Media item removed successfully."
                        : "Media items removed successfully."
                )
            )
        }
        catch {
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Remove failed",
                    message: error.displayMessage
                )
            )
        }
    }
}
