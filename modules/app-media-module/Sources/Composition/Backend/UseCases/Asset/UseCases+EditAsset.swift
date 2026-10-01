import FeatherDomain
import FeatherInfrastructure
public import MediaApplication

extension UseCases {

    public func makeEditAsset() -> EditMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            objectKeyGenerator: storageContext.objectKeyGenerator
        )
    }
}
