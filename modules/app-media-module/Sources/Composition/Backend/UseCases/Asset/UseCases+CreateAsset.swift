public import MediaApplication

extension UseCases {

    public func makeCreateAsset() -> CreateMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storageContext: storageContext
        )
    }
}
