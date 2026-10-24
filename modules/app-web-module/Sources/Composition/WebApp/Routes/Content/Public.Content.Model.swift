import FeatherModuleKit
import Hummingbird
import WebModule

extension Public.Content {
    struct Model: Sendable {
        let metadata: PublicContent.Metadata.Base
        let results: [PublicContentProvider.Output]
        let status: HTTPResponse.Status

        init(
            metadata: PublicContent.Metadata.Base,
            results: [PublicContentProvider.Output],
            status: HTTPResponse.Status = .ok
        ) {
            self.metadata = metadata
            self.results = results
            self.status = status
        }
    }
}
