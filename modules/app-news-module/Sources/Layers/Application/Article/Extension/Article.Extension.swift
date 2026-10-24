import NewsModule

extension Article {
    public enum Extension {}
}

extension Article.Extension {
    public protocol Interface: Sendable {
        associatedtype CreateInput: Sendable
        associatedtype UpdateInput: Sendable
        associatedtype Detail: Sendable

        func load(
            context: Context
        ) async throws -> Detail

        func load(
            contexts: [Context]
        ) async throws -> [String: Detail]

        func create(
            context: Context,
            input: CreateInput
        ) async throws -> Detail

        func update(
            context: Context,
            input: UpdateInput
        ) async throws -> Detail

        func remove(
            context: Context
        ) async throws
    }
}

extension Article.Extension.Interface {
    public func load(
        contexts: [Article.Extension.Context]
    ) async throws -> [String: Detail] {
        try await withThrowingTaskGroup(
            of: [String: Detail].self
        ) { group in
            for context in contexts {
                group.addTask {
                    [context.articleID: try await load(context: context)]
                }
            }

            var result: [String: Detail] = [:]
            for try await details in group {
                for entry in details {
                    result[entry.key] = entry.value
                }
            }
            return result
        }
    }
}
