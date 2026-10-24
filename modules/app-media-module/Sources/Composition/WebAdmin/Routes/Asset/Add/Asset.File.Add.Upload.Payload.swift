import Hummingbird
import MediaModule
import OpenAPIRuntime

extension Asset.File.Add.Upload {
    struct Payload: Sendable {
        let parentId: String
        let fileName: String
        let `extension`: String
        let title: String
        let altText: String
        let view: String
        let content: HTTPBody
    }
}
