public import MediaApplication

extension UseCases {
    public func makeGetVariant() -> GetMediaVariant {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
