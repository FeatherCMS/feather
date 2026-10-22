import Foundation

enum WebBackendDateMapping {
    static func timestamp(_ date: Date?) -> Double? {
        date?.timeIntervalSince1970
    }
}
