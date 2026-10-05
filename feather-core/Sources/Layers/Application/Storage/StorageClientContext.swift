public import FeatherDomain
public import FeatherStorage

/// Application-lifetime storage dependencies shared by module composition.
public struct StorageClientContext: Sendable {
    public let storage: any StorageClient
    public let objectKeyGenerator: any ObjectKeyGenerator

    public init(
        storage: any StorageClient,
        objectKeyGenerator: any ObjectKeyGenerator
    ) {
        self.storage = storage
        self.objectKeyGenerator = objectKeyGenerator
    }
}
