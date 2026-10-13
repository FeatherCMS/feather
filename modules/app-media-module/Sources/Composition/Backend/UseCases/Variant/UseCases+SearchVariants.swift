public import MediaApplication

extension UseCases {
    public func makeSearchVariants() -> SearchMediaVariants {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
