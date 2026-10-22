public import WebApplication
import WebDomain
public import WebModule

public func resolveNewsMetadataDetails(
    metadata: any WebModule.Metadata.Query.Interface,
    referenceType: String,
    referenceIDs: [String]
) async throws -> [WebModule.Metadata.Detail.Output] {
    try await metadata.resolveDetails(
        referenceType: referenceType,
        referenceIDs: Array(Set(referenceIDs))
    )
}
