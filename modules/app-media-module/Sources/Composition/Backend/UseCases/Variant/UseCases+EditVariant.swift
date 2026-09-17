import MediaApplication

extension UseCases {
    public func makeEditVariant() -> EditMediaVariant {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
