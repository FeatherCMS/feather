public import MediaApplication

extension UseCases {
    public func makeEditVariantProcessor() -> EditMediaVariantProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
