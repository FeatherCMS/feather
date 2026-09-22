import MediaApplication

extension UseCases {

    public func makeRemoveAsset() -> RemoveMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storage: storage,
            storageKeyShard: storageKeyShard
        )
    }
}
