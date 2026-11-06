import FeatherWebAdmin
public import WebModule

extension WebModule.Metadata.Status {
    public enum Repository {}
}

extension WebModule.Metadata.Status.Repository {
    public protocol Interface: Sendable {
        func update(
            referenceType: String,
            referenceID: String,
            status: String
        ) async throws
    }
}
