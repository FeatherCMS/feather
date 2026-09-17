import MediaApplication

extension UseCases {
    public func makeCreateVariantProcessor() -> CreateMediaVariantProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
