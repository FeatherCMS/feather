public import Foundation
public import Hummingbird

extension HTTPError: @retroactive LocalizedError {
    public var errorDescription: String? {
        body ?? status.description
    }
}
