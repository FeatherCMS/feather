import MediaApplication

extension UseCases {
    public func makeSearchVariantProcessors() -> SearchMediaVariantProcessors { .init(authorizer: authorizer, transaction: writeTransaction()) }
}
