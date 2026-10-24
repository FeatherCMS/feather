import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
public import FeatherModuleKit
import FeatherStorage
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure
import MediaModule
import NIOCore

extension UseCases {
    public func deleteAssetNodesAndFiles(subject: Subject, assetIds: [String])
        async throws
    {
        _ = try await makeRemoveAsset()
            .execute(subject: subject, input: .init(ids: assetIds))
    }
}
