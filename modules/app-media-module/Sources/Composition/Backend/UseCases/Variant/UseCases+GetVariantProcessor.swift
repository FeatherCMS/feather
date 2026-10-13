public import MediaApplication

extension UseCases {
    public func makeGetVariantProcessor() -> GetMediaVariantProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
