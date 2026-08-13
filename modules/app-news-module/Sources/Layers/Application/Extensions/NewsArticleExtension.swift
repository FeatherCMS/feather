import FeatherApplication
import FeatherContracts

public protocol NewsArticleExtension: Sendable {
    associatedtype CreateInput: Sendable
    associatedtype UpdateInput: Sendable
    associatedtype Detail: Sendable

    func load(
        context: NewsArticleExtensionContext
    ) async throws -> Detail

    func load(
        contexts: [NewsArticleExtensionContext]
    ) async throws -> [String: Detail]

    func create(
        context: NewsArticleExtensionContext,
        input: CreateInput
    ) async throws -> Detail

    func update(
        context: NewsArticleExtensionContext,
        input: UpdateInput
    ) async throws -> Detail

    func remove(
        context: NewsArticleExtensionContext
    ) async throws
}

extension NewsArticleExtension {
    public func load(
        contexts: [NewsArticleExtensionContext]
    ) async throws -> [String: Detail] {
        try await withThrowingTaskGroup(
            of: (String, Detail).self
        ) { group in
            for context in contexts {
                group.addTask {
                    (
                        context.articleID,
                        try await load(context: context)
                    )
                }
            }

            var result: [String: Detail] = [:]
            for try await (articleID, detail) in group {
                result[articleID] = detail
            }
            return result
        }
    }
}
