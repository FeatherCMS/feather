import FeatherModuleKit
import FeatherWebAdmin
import Foundation

enum MetadataDateDefaults {

    static func publicationDate(
        _ value: String?,
        dateFormatter: AdminDateFormatter
    ) -> String {
        let trimmed =
            value?.whitespaceTrimmed ?? ""
        if trimmed.isEmpty {
            return dateFormatter.formatDateTimeInput(Date())
        }
        return trimmed
    }
}
