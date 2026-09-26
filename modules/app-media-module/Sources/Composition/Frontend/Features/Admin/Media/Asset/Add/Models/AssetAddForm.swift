import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaHTTPBodySequence: Sendable, AsyncSequence {
    typealias Element = ArraySlice<UInt8>

    struct AsyncIterator: AsyncIteratorProtocol {
        var iterator: RequestBody.AsyncIterator

        mutating func next() async throws -> ArraySlice<UInt8>? {
            let buffer = try await iterator.next(isolation: nil)
            guard let buffer else { return nil }
            return ArraySlice(buffer.readableBytesView)
        }
    }

    let body: RequestBody

    func makeAsyncIterator() -> AsyncIterator {
        .init(iterator: body.makeAsyncIterator())
    }
}

struct AssetAddForm: Decodable {
    var parentId: String = ""
    var fileName: String = ""
    var `extension`: String = "bin"
    var title: String = ""
    var altText: String = ""
    var data: String = ""
    var view: String = "grid"
}

struct AssetAddUpload: Sendable {
    let parentId: String
    let fileName: String
    let `extension`: String
    let title: String
    let altText: String
    let view: String
    let content: HTTPBody
}
