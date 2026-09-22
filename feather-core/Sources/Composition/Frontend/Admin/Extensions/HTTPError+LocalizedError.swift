import Hummingbird
import Foundation

extension HTTPError: @retroactive LocalizedError {
    public var errorDescription: String? {
        body ?? status.description
    }
}
