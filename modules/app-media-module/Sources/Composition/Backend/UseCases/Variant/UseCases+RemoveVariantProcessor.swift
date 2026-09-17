import MediaApplication

extension UseCases {
    public func makeRemoveVariantProcessor() -> RemoveMediaVariantProcessor { .init(authorizer: authorizer, transaction: writeTransaction()) }
}
