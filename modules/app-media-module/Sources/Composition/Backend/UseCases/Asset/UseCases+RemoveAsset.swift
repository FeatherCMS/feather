public import MediaApplication

extension UseCases {

    public func makeRemoveAsset() -> RemoveMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storageContext: storageContext
        )
    }
}
