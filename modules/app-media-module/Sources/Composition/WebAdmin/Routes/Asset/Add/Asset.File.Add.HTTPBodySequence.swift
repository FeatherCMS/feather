import Hummingbird
import MediaModule

extension Asset.File.Add {
    struct HTTPBodySequence: Sendable, AsyncSequence {
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
}
