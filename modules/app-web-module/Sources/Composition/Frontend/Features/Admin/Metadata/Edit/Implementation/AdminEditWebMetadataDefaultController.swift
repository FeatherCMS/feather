import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import WebApplication

struct AdminEditWebMetadataDefaultController:
    AdminEditWebMetadataController
{
    let templateOptions: [WebPageTemplateOption]
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebMetadataInteractor,
            presenter: any AdminEditWebMetadataPresenter
        )

    func getEditWebMetadataForContent(
        request: Request,
        context: AppRequestContext,
        referenceType: String,
        navigationTabs: [AdminPillTabs.Link]
    ) async throws -> HTMLResponse {
        try await renderEditWebMetadata(
            request: request,
            context: context,
            referenceType: referenceType,
            navigationTabs: navigationTabs
        )
    }

    func postEditWebMetadataForContent(
        request: Request,
        context: AppRequestContext,
        referenceType: String,
        navigationTabs: [AdminPillTabs.Link]
    ) async throws -> Response {
        try await renderPostEditWebMetadata(
            request: request,
            context: context,
            referenceType: referenceType,
            navigationTabs: navigationTabs
        )
    }

    func getEditWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        try await renderEditWebMetadata(
            request: request,
            context: context,
            referenceType: nil,
            navigationTabs: []
        )
    }

    private func renderEditWebMetadata(
        request: Request,
        context: AppRequestContext,
        referenceType: String?,
        navigationTabs: [AdminPillTabs.Link]
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try metadataID(context: context)
        let permissions = context.currentUserPermissions

        do {
            let entry = try await loadEntry(
                runtime: runtime,
                id: id,
                context: context,
                referenceType: referenceType
            )
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    referenceType: entry.referenceType,
                    referenceId: entry.referenceId,
                    slug: entry.slug,
                    publicationDate: entry.publicationDate,
                    expirationDate: entry.expirationDate,
                    status: entry.status,
                    template: entry.template,
                    templateOptions: templateOptions,
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
                permissions: permissions,
                navigationTabs: navigationTabs
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
        try await renderPostEditWebMetadata(
            request: request,
            context: context,
            referenceType: nil,
            navigationTabs: []
        )
    }

    private func renderPostEditWebMetadata(
        request: Request,
        context: AppRequestContext,
        referenceType: String?,
        navigationTabs: [AdminPillTabs.Link]
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try metadataID(context: context)
        let permissions = context.currentUserPermissions
        let entry = try await loadEntry(
            runtime: runtime,
            id: id,
            context: context,
            referenceType: referenceType
        )
        let metadataID = entry.id
        var lastPayload: WebMetadataFormInput?

        do {
            let payload = try await request.decode(
                as: WebMetadataFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: metadataID, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: request.uri.path,
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
                template: lastPayload?.normalizedTemplate ?? "default",
                templateOptions: templateOptions,
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
                    permissions: permissions,
                    navigationTabs: navigationTabs
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
                template: lastPayload?.normalizedTemplate ?? "default",
                templateOptions: templateOptions,
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
                    permissions: permissions,
                    navigationTabs: navigationTabs
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
                template: lastPayload?.normalizedTemplate ?? "default",
                templateOptions: templateOptions,
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
                    permissions: permissions,
                    navigationTabs: navigationTabs
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
        template: String = "default",
        templateOptions: [WebPageTemplateOption] = [],
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
            template: .init(
                key: "template",
                label: "Template",
                value: template,
                error: nil
            ),
            templateOptions: templateOptions,
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

    private func metadataID(
        context: AppRequestContext
    ) throws -> String {
        if let metadataID = context.parameters.get(
            "metadataID",
            as: String.self
        ) {
            return metadataID
        }
        return try context.requiredID()
    }

    private func loadEntry(
        runtime: (
            interactor: any AdminEditWebMetadataInteractor,
            presenter: any AdminEditWebMetadataPresenter
        ),
        id: String,
        context: AppRequestContext,
        referenceType: String?
    ) async throws -> WebMetadataDetailsModel {
        if let referenceType,
            let contentID = context.parameters.get(
                "contentID",
                as: String.self
            )
        {
            return try await runtime.interactor.load(
                referenceType: referenceType,
                referenceID: contentID
            )
        }
        return try await runtime.interactor.load(id: id)
    }

}
