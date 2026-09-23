import FeatherContracts

public struct WebPublicContentEventContext<T: Sendable>: ExecutionContext {
    public let baseMetadata: PublicContent.Metadata.Base
    public let runtime: T

    public init(
        baseMetadata: PublicContent.Metadata.Base,
        runtime: T
    ) {
        self.baseMetadata = baseMetadata
        self.runtime = runtime
    }
}
