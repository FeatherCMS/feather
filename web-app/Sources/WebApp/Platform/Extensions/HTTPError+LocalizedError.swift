import Foundation
import Hummingbird

extension HTTPError: @retroactive LocalizedError {
    public var errorDescription: String? {
        body ?? status.description
    }
}
