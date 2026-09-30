public import FeatherStorage

public struct StorageContext: Sendable {
    public let storage: any StorageClient
    public let objectKeyGenerator: any ObjectKeyGenerator

    public init(
        storage: any StorageClient,
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    ) {
        self.storage = storage
        self.objectKeyGenerator = objectKeyGenerator
    }
}
