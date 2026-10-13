public import MediaApplication

extension UseCases {
    public func makeRemoveVariant() -> RemoveMediaVariant {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
