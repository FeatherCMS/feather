import FeatherContracts
import Foundation
import SystemContracts
import WebAppAPI
import WebContracts

struct AppPublicContentDefaultInteractor: AppPublicContentInteractor {
    let repository: any AppPublicContentRepository
    let events: any EventPublisher
    let sessionToken: String?
    let contentRenderer: any WebContentRenderer

    func resolve(
        path: String
    ) async throws -> AppPublicResolvedContent? {
        let slug = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let metadata = try await repository.resolveWebRoute(slug: slug)
        else {
            let templateIdentifier = slug.isEmpty ? "home" : "not-found"
            return try await fallbackContent(
                path: slug,
                templateIdentifier: templateIdentifier,
                isNotFound: !slug.isEmpty
            )
        }

        let payload = try await resolveModuleContent(
            path: slug,
            templateIdentifier: metadata.template,
            referenceType: metadata.referenceType,
            referenceID: metadata.referenceId
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
        templateIdentifier: String,
        isNotFound: Bool
    ) async throws -> AppPublicResolvedContent? {
        let payload = try await resolveModuleContent(
            path: path,
            templateIdentifier: templateIdentifier,
            referenceType: "",
            referenceID: ""
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
        templateIdentifier: String?,
        referenceType: String,
        referenceID: String
    ) async throws -> [String: Any] {
        let request = WebPublicContentEventContext(
            path: path,
            templateIdentifier: templateIdentifier,
            sessionToken: sessionToken,
            referenceType: referenceType,
            referenceID: referenceID
        )
        let results = try await events.trigger(
            event: WebPublicContentProvider(request: request),
            using: request
        )
        var context: [String: Any] = [:]
        for result in results.compactMap({ $0 }) {
            for (key, value) in result.payload {
                context[key] = value
            }
        }
        return await renderContent(in: context, requestPath: path)
    }

    private func renderContent(
        in payload: [String: Any],
        requestPath: String
    ) async -> [String: Any] {
        var result = payload
        for (key, value) in payload {
            guard key == "page", let page = value as? [String: Any]
            else { continue }
            result[key] = await renderPage(
                page,
                requestPath: requestPath
            )
        }
        return result
    }

    private func renderPage(
        _ page: [String: Any],
        requestPath: String
    ) async -> [String: Any] {
        var result = page
        let markdown: String?
        if let contents = page["contents"] as? [String: Any] {
            markdown = contents["html"] as? String
        }
        else if let contents = page["contents"] as? [String: String] {
            markdown = contents["html"]
        }
        else {
            markdown = page["content"] as? String
        }
        guard let markdown else { return result }
        var renderedContents: [String: Any] =
            (page["contents"] as? [String: Any])
            ?? ["html": markdown]
        renderedContents["html"] = await contentRenderer.render(
            markdown: markdown,
            requestPath: requestPath
        )
        result["contents"] = renderedContents
        return result
    }
}
