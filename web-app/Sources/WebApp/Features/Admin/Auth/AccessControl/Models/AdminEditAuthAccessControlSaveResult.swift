import Foundation

enum AdminEditAuthAccessControlSaveResult: Sendable {
    case edited
    case render(AdminEditAuthAccessControlState)
}
