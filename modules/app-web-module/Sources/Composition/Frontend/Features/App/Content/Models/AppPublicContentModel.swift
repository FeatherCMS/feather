import FeatherContracts
import Hummingbird
import WebContracts

struct AppPublicContentModel: Sendable {
    let metadata: PublicContent.Metadata.Base
    let results: [WebPublicContentProvider.Output]
    let status: HTTPResponse.Status

    init(
        metadata: PublicContent.Metadata.Base,
        results: [WebPublicContentProvider.Output],
        status: HTTPResponse.Status = .ok
    ) {
        self.metadata = metadata
        self.results = results
        self.status = status
    }
}
