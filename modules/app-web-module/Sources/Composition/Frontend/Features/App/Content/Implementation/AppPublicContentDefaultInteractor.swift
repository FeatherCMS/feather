import FeatherAdmin
import FeatherContracts
import Foundation
import SystemContracts
import WebAppAPI
import WebContracts

struct AppPublicContentDefaultInteractor: AppPublicContentInteractor {
    let repository: any AppPublicContentRepository
    let events: any EventPublisher
    let runtime: RuntimeBuilderContext
    let contentRenderer: any WebContentRenderer

    func resolve(
        slug: String
    ) async throws -> AppPublicResolvedContent? {
        guard
            let metadata = try await repository.resolveWebRoute(slug: slug)
        else {
            let templateIdentifier = slug.isEmpty ? "home" : "not-found"
            let baseMetadata = PublicContent.Metadata.Base(
                referenceType: "",
                referenceId: "",
                slug: slug,
                template: templateIdentifier
            )
            return try await fallbackContent(
                path: slug,
                baseMetadata: baseMetadata,
                templateIdentifier: templateIdentifier,
                isNotFound: !slug.isEmpty,
            )
        }

        let baseMetadata = PublicContent.Metadata.Base(
            referenceType: metadata.referenceType,
            referenceId: metadata.referenceId,
            slug: metadata.slug,
            template: metadata.template
        )
        let payload = try await resolveModuleContent(
            path: slug,
            baseMetadata: baseMetadata
        )
        return .init(
            moduleContext: .init(
                templateIdentifier: metadata.template,
                payload: payload
            )
        )
    }

    private func fallbackContent(
        path: String,
        baseMetadata: PublicContent.Metadata.Base,
        templateIdentifier: String,
        isNotFound: Bool
    ) async throws -> AppPublicResolvedContent? {
        let payload = try await resolveModuleContent(
            path: path,
            baseMetadata: baseMetadata
        )
        return .init(
            moduleContext: .init(
                templateIdentifier: templateIdentifier,
                payload: payload
            ),
            isNotFound: isNotFound
        )
    }

    private func resolveModuleContent(
        path: String,
        baseMetadata: PublicContent.Metadata.Base
    ) async throws -> [String: any Sendable] {
        let context = WebPublicContentEventContext<RuntimeBuilderContext>(
            baseMetadata: baseMetadata,
            runtime: runtime
        )
        let results = try await events.trigger(
            event: WebPublicContentProvider(),
            using: context
        )
        // TODO: add global context stuff... base urls, etc.
        // WebPublicContentResult -> getPayload function
        var payload: [String: any Sendable] = [:]
        for result in results.compactMap({ $0 }) {
            for (key, value) in result.payload {
                payload[key] = value
            }
        }
        return await renderContent(in: payload, requestPath: path)
    }

    private func renderContent(
        in payload: [String: any Sendable],
        requestPath: String
    ) async -> [String: any Sendable] {
        var result = payload
        for (key, value) in payload {
            guard
                key == "page",
                let page = value as? [String: any Sendable]
            else { continue }
            result[key] = await renderPage(
                page,
                requestPath: requestPath
            )
        }
        return result
    }

    private func renderPage(
        _ page: [String: any Sendable],
        requestPath: String
    ) async -> [String: any Sendable] {
        var result = page
        let markdown: String?
        if let contents = page["contents"] as? [String: any Sendable] {
            markdown = contents["html"] as? String
        }
        else if let contents = page["contents"] as? [String: String] {
            markdown = contents["html"]
        }
        else {
            markdown = page["content"] as? String
        }
        guard let markdown else { return result }
        var renderedContents: [String: any Sendable] =
            (page["contents"] as? [String: any Sendable])
            ?? ["html": markdown]
        renderedContents["html"] = await contentRenderer.render(
            markdown: markdown,
            requestPath: requestPath
        )
        result["contents"] = renderedContents
        return result
    }
}
