import FeatherModuleKit
import Hummingbird
import WebModule

extension Public.Content {
    struct Model: Sendable {
        let metadata: FeatherModuleKit.PublicContent.Metadata.Base
        let results: [WebModule.Event.Provider.Output]
        let status: HTTPResponse.Status

        init(
            metadata: FeatherModuleKit.PublicContent.Metadata.Base,
            results: [WebModule.Event.Provider.Output],
            status: HTTPResponse.Status = .ok
        ) {
            self.metadata = metadata
            self.results = results
            self.status = status
        }
    }
}
