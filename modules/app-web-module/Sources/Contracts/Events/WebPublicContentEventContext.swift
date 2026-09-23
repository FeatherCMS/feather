import FeatherContracts

public struct WebPublicContentEventContext<T: Sendable>: Sendable, ExecutionContext
{
    public let templateIdentifier: String?
    public let referenceID: String?
    public let runtime: T

    public init(
        templateIdentifier: String?,
        referenceID: String? = nil,
        runtime: T
    ) {
        self.templateIdentifier = templateIdentifier
        self.referenceID = referenceID
        self.runtime = runtime
    }
}
