import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminEditWebMetadataDefaultController:
    Sendable
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminEditWebMetadataInteractor,
            any AdminEditWebMetadataPresenter
        >

    func getEditWebMetadataForContent(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> HTMLResponse {
        try await renderEditWebMetadata(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    func postEditWebMetadataForContent(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> Response {
        try await renderPostEditWebMetadata(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    private func renderEditWebMetadata(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let id = try metadataID(context: context)
        let permissions = context.currentUserPermissions
        do {
            let entry = try await loadEntry(
                runtime: runtime,
                id: id,
                context: context,
                referenceType: configuration.referenceType
            )
            let templateOptions = try await runtime.interactor
                .getTemplateOptions()
            return try await runtime.presenter.renderEditPage(
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
                permissions: permissions,
                navigationTabs: configuration.navigationTabs,
                configuration: configuration
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions,
                configuration: configuration
            )
        }
    }

    private func renderPostEditWebMetadata(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let id = try metadataID(context: context)
        let permissions = context.currentUserPermissions
        let entry = try await loadEntry(
            runtime: runtime,
            id: id,
            context: context,
            referenceType: configuration.referenceType
        )
        let metadataID = entry.id
        let templateOptions = try await runtime.interactor
            .getTemplateOptions()
        var lastPayload: WebMetadataFormInput?

        do {
            let payload = try await request.decode(
                as: WebMetadataFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: metadataID, input: payload)

            return AdminNotificationFlash.redirect(
                to: request.uri.path,
                notification: .init(
                    title: "Saved",
                    message: "Web metadata edited successfully."
                )
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
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions,
                    navigationTabs: configuration.navigationTabs,
                    configuration: configuration
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
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions,
                    navigationTabs: configuration.navigationTabs,
                    configuration: configuration
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
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions,
                    navigationTabs: configuration.navigationTabs,
                    configuration: configuration
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
                label: "Image",
                value: imageUrl,
                error: nil
            ),
            selectedImageAsset: NewAdminMediaAsset.metadataImageURL(
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
        context: AuthenticatedRequestContext
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
        context: AuthenticatedRequestContext,
        referenceType: String?
    ) async throws -> WebMetadataDetailsModel {
        if let referenceType,
            let contentID = context.parameters.get(
                "contentID",
                as: String.self
            )
                ?? context.parameters.get(
                    "id",
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
