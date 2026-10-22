public import WebApplication
public import WebDomain

public func resolveNewsMetadataDetails(
    metadata: any Metadata.Query.Interface,
    referenceType: String,
    referenceIDs: [String]
) async throws -> [Metadata.Detail.Output] {
    try await metadata.resolveDetails(
        referenceType: referenceType,
        referenceIDs: Array(Set(referenceIDs))
    )
}
