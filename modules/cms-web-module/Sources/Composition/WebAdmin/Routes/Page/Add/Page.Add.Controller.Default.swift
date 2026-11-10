import FeatherInfrastructure
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Add.Controller {
    struct Default: Interface {
        let routes: Page.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Page.Add.Interactor.Interface,
                any Page.Add.Presenter.Interface
            >

        func getAddPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            return try await runtime.presenter.renderAddPage(
                state: formState(
                    context: context,
                    slugPrefix: slugPrefix(context: context),
                    mediaDraftID: newMediaDraftID()
                ),
                permissions: context.currentUserPermissions
            )
        }

        func postAddPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            var lastPayload: Page.Form.Input?
            let mediaDraftID = validMediaDraftID(
                request.queryString("mediaDraftID")
            ) ?? newMediaDraftID()

            do {
                let payload = try await request.decode(
                    as: Page.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                let id = try await runtime.interactor.execute(
                    input: payload,
                    mediaDraftID: mediaDraftID
                )
                return runtime.presenter.renderCreated(id: id)
            }
            catch let error as ValidationError {
                var errors: [String: String] = [:]
                for failure in error.failures {
                    errors[failure.key] = failure.message
                }
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    slugPrefix: slugPrefix(context: context),
                    mediaDraftID: mediaDraftID
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .renderAddPage(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    slugPrefix: slugPrefix(context: context),
                    mediaDraftID: mediaDraftID
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .renderAddPage(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    slugPrefix: slugPrefix(context: context),
                    mediaDraftID: mediaDraftID
                )
                state.error = error.displayMessage
                return try await runtime.presenter
                    .renderAddPage(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
        }

        private func formState(
            context: AuthenticatedRequestContext,
            title: String = "",
            excerpt: String = "",
            content: String = "",
            imageAssetId: String? = nil,
            metadata: AdminMetadataFormValue? = nil,
            slugPrefix: String? = nil,
            mediaDraftID: String? = nil
        ) -> Page.Form.Component.State {
            .init(
                title: .init(
                    key: "title",
                    label: "Title",
                    value: title,
                    error: nil
                ),
                excerpt: .init(
                    key: "excerpt",
                    label: "Excerpt",
                    value: excerpt,
                    error: nil
                ),
                content: .init(
                    key: "content",
                    label: "Content",
                    value: content,
                    error: nil
                ),
                imageAssetId: .init(
                    key: "imageAssetId",
                    label: "Page image",
                    value: imageAssetId,
                    error: nil
                ),
                selectedImageAsset: nil,
                mediaDraftID: mediaDraftID,
                metadata: WebModule.Metadata.FieldStateFactory.make(
                    metadata,
                    dateFormatter: context.adminDateFormatter,
                    slugPrefix: slugPrefix
                ),
                error: nil,
                success: nil
            )
        }

        private func slugPrefix(
            context: AuthenticatedRequestContext
        ) -> String {
            "/"
        }

        private func newMediaDraftID() -> String {
            NanoIDGenerator().generate()
                .lowercased()
                .replacingOccurrences(of: "_", with: "-")
        }

        private func validMediaDraftID(_ id: String?) -> String? {
            guard let id, !id.isEmpty,
                id.unicodeScalars.allSatisfy({
                    CharacterSet.alphanumerics.contains($0)
                        || $0 == "_" || $0 == "-"
                })
            else { return nil }
            return id.lowercased().replacingOccurrences(of: "_", with: "-")
        }
    }
}
