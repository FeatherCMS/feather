public import FeatherApplication
public import FeatherInfrastructure
public import FeatherModuleKit
public import MediaApplication
public import MediaModule

public struct UseCases: Sendable {
    public struct AssociatedVariantFile: Sendable {
        public let assetId: String
        public let slugPath: String
        public let filename: String
        public let variantId: String
        public let key: String
        public let name: String
        public let url: String
        public let `extension`: String
        public let objectKey: String
    }

    let databaseContext: DatabaseClientContext
    let storageContext: StorageClientContext
    let jobs: any Asset.File.GenerateVariant.JobController.Interface
    let authorizer: any Authorizer

    public init(
        databaseContext: DatabaseClientContext,
        storageContext: StorageClientContext,
        authorizer: any Authorizer,
        jobs: any Asset.File.GenerateVariant.JobController.Interface
    ) {
        self.databaseContext = databaseContext
        self.storageContext = storageContext
        self.jobs = jobs
        self.authorizer = authorizer
    }

}
