import FeatherModuleKit
import Hummingbird
import WebModule

extension Public.Content {
    struct Model: Sendable {
        let metadata: FeatherModuleKit.PublicContent.Metadata.Base
        let results: [WebModule.Public.Content.Event.Provider.Output]
        let status: HTTPResponse.Status
        let canonicalPath: String

        init(
            metadata: FeatherModuleKit.PublicContent.Metadata.Base,
            results: [WebModule.Public.Content.Event.Provider.Output],
            status: HTTPResponse.Status = .ok,
            canonicalPath: String
        ) {
            self.metadata = metadata
            self.results = results
            self.status = status
            self.canonicalPath = canonicalPath
        }
    }
}
