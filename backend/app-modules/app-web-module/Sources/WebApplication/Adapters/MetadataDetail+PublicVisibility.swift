import Foundation
import WebDomain

public extension MetadataDetail {
    func isPublic(
        at date: Date
    ) -> Bool {
        guard status == .published else {
            return false
        }
        guard let publicationDate, publicationDate <= date else {
            return false
        }
        if let expirationDate, expirationDate <= date {
            return false
        }
        return true
    }

    func isDirectlyAccessible(
        at date: Date
    ) -> Bool {
        switch status {
        case .draft:
            return true
        case .published:
            return isPublic(at: date)
        case .archived:
            return false
        }
    }
}
