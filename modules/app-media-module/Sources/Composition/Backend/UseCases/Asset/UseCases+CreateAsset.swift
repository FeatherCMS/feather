public import MediaApplication

extension UseCases {

    public func makeCreateAsset() -> CreateMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storage: storage,
            storageKeyShard: storageKeyShard
        )
    }
}
