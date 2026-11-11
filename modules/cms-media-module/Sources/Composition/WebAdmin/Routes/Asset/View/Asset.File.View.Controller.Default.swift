import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import NIOCore
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.File.View.Interactor.Interface,
                any Asset.File.View.Presenter.Interface
            >

        func getMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let id = try context.requiredID()
            let permissions = context.currentUserAdminListActions
            do {
                let model = try await interactor.getMediaAsset(id: id)
                return try await presenter.renderDetailsPage(
                    model: model,
                    id: id,
                    permissions: permissions,
                    error: nil
                )
            }
            catch {
                return try await presenter.renderDetailsPage(
                    model: nil,
                    id: id,
                    permissions: permissions,
                    error: error.displayMessage
                )
            }
        }

        func getMediaAssetStatus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let variants = request.queryString("variants")?
                .split(separator: ",")
                .map(String.init) ?? []
            do {
                let asset = try await runtime.interactor.getMediaAssetStatus(
                    id: id,
                    variants: variants
                )
                let payload = StatusPayload(
                    status: asset.status,
                    variants: asset.variants.map {
                        .init(key: $0.key, url: $0.url)
                    }
                )
                let data = try JSONEncoder().encode(payload)
                var buffer = ByteBufferAllocator().buffer(capacity: data.count)
                buffer.writeBytes(data)
                return Response(
                    status: .ok,
                    headers: [
                        .contentType: "application/json; charset=utf-8",
                        .cacheControl: "no-store",
                    ],
                    body: .init(byteBuffer: buffer)
                )
            }
            catch let error as OpenAPIRepositoryError {
                return Response(status: error.httpStatus)
            }
        }
    }
}

extension Asset.File.View.Controller.Default {
    private struct StatusPayload: Encodable {
        struct Variant: Encodable {
            let key: String
            let url: String
        }

        let status: String
        let variants: [Variant]
    }
}
