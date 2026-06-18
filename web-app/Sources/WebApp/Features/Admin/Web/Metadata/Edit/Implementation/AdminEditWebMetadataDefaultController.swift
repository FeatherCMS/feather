import FeatherValidation
import HTML
import Hummingbird

struct AdminEditWebMetadataDefaultController:
    AdminEditWebMetadataController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebMetadataInteractor,
            presenter: any AdminEditWebMetadataPresenter
        )

    func getEditWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let entry = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    referenceType: entry.referenceType,
                    referenceId: entry.referenceId,
                    slug: entry.slug,
                    publicationDate: entry.publicationDate,
                    expirationDate: entry.expirationDate,
                    status: entry.status,
                    title: entry.title,
                    excerpt: entry.excerpt,
                    imageUrl: entry.imageUrl,
                    canonicalUrl: entry.canonicalUrl,
                    noIndex: entry.noIndex,
                    primaryKeyword: entry.primaryKeyword,
                    cssCodeInjection: entry.cssCodeInjection,
                    javascriptCodeInjection: entry.javascriptCodeInjection,
                    structuredDataCodeInjection: entry
                        .structuredDataCodeInjection
                ),
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let entry = try await runtime.interactor.load(id: id)
        var lastPayload: WebMetadataFormInput?

        do {
            let payload = try await request.decode(
                as: WebMetadataFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/metadata/\(id)/edit/",
                        title: "Saved",
                        message: "Web metadata edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = formState(
                referenceType: entry.referenceType,
                referenceId: entry.referenceId,
                slug: lastPayload?.normalizedSlug ?? "",
                publicationDate: lastPayload?.normalizedPublicationDate ?? "",
                expirationDate: lastPayload?.normalizedExpirationDate ?? "",
                status: lastPayload?.normalizedStatus ?? "draft",
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                imageUrl: lastPayload?.normalizedImageUrl ?? "",
                canonicalUrl: lastPayload?.normalizedCanonicalUrl ?? "",
                noIndex: lastPayload?.noIndex.value ?? false,
                primaryKeyword: lastPayload?.normalizedPrimaryKeyword ?? "",
                cssCodeInjection: lastPayload?.normalizedCSSCodeInjection ?? "",
                javascriptCodeInjection: lastPayload?
                    .normalizedJavaScriptCodeInjection ?? "",
                structuredDataCodeInjection: lastPayload?
                    .normalizedStructuredDataCodeInjection ?? ""
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(
                referenceType: entry.referenceType,
                referenceId: entry.referenceId,
                slug: lastPayload?.normalizedSlug ?? "",
                publicationDate: lastPayload?.normalizedPublicationDate ?? "",
                expirationDate: lastPayload?.normalizedExpirationDate ?? "",
                status: lastPayload?.normalizedStatus ?? "draft",
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                imageUrl: lastPayload?.normalizedImageUrl ?? "",
                canonicalUrl: lastPayload?.normalizedCanonicalUrl ?? "",
                noIndex: lastPayload?.noIndex.value ?? false,
                primaryKeyword: lastPayload?.normalizedPrimaryKeyword ?? "",
                cssCodeInjection: lastPayload?.normalizedCSSCodeInjection ?? "",
                javascriptCodeInjection: lastPayload?
                    .normalizedJavaScriptCodeInjection ?? "",
                structuredDataCodeInjection: lastPayload?
                    .normalizedStructuredDataCodeInjection ?? ""
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(
                referenceType: entry.referenceType,
                referenceId: entry.referenceId,
                slug: lastPayload?.normalizedSlug ?? "",
                publicationDate: lastPayload?.normalizedPublicationDate ?? "",
                expirationDate: lastPayload?.normalizedExpirationDate ?? "",
                status: lastPayload?.normalizedStatus ?? "draft",
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                imageUrl: lastPayload?.normalizedImageUrl ?? "",
                canonicalUrl: lastPayload?.normalizedCanonicalUrl ?? "",
                noIndex: lastPayload?.noIndex.value ?? false,
                primaryKeyword: lastPayload?.normalizedPrimaryKeyword ?? "",
                cssCodeInjection: lastPayload?.normalizedCSSCodeInjection ?? "",
                javascriptCodeInjection: lastPayload?
                    .normalizedJavaScriptCodeInjection ?? "",
                structuredDataCodeInjection: lastPayload?
                    .normalizedStructuredDataCodeInjection ?? ""
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        referenceType: String = "",
        referenceId: String = "",
        slug: String = "",
        publicationDate: String = "",
        expirationDate: String = "",
        status: String = "draft",
        title: String = "",
        excerpt: String = "",
        imageUrl: String = "",
        canonicalUrl: String = "",
        noIndex: Bool = false,
        primaryKeyword: String = "",
        cssCodeInjection: String = "",
        javascriptCodeInjection: String = "",
        structuredDataCodeInjection: String = ""
    ) -> WebMetadataForm.State {
        .init(
            referenceType: .init(
                key: "referenceType",
                label: "Reference type",
                value: referenceType,
                error: nil
            ),
            referenceId: .init(
                key: "referenceId",
                label: "Reference ID",
                value: referenceId,
                error: nil
            ),
            slug: .init(key: "slug", label: "Slug", value: slug, error: nil),
            publicationDate: .init(
                key: "publicationDate",
                label: "Publication date & time",
                value: publicationDate,
                error: nil
            ),
            expirationDate: .init(
                key: "expirationDate",
                label: "Expiration date & time",
                value: expirationDate,
                error: nil
            ),
            status: .init(
                key: "status",
                label: "Status",
                value: status,
                error: nil
            ),
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
            imageUrl: .init(
                key: "imageUrl",
                label: "Image URL",
                value: imageUrl,
                error: nil
            ),
            selectedImageAsset: AdminMediaAssetReferenceModel.metadataImageURL(
                imageUrl
            ),
            canonicalUrl: .init(
                key: "canonicalUrl",
                label: "Canonical URL",
                value: canonicalUrl,
                error: nil
            ),
            noIndex: .init(
                key: "noIndex",
                label: "No index",
                value: noIndex,
                error: nil
            ),
            primaryKeyword: .init(
                key: "primaryKeyword",
                label: "Primary keyword",
                value: primaryKeyword,
                error: nil
            ),
            cssCodeInjection: .init(
                key: "cssCodeInjection",
                label: "CSS code injection",
                value: cssCodeInjection,
                error: nil
            ),
            javascriptCodeInjection: .init(
                key: "javascriptCodeInjection",
                label: "JavaScript code injection",
                value: javascriptCodeInjection,
                error: nil
            ),
            structuredDataCodeInjection: .init(
                key: "structuredDataCodeInjection",
                label: "Structured data",
                value: structuredDataCodeInjection,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }
}
