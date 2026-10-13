public import MediaApplication

extension UseCases {
    public func makeCreateVariant() -> CreateMediaVariant {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
