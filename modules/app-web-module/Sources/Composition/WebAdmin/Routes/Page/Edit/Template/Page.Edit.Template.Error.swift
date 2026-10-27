import Foundation
import WebModule

extension Page.Edit.Template {
    enum Error: LocalizedError {
        case templateNotFound
        case requiredValue(String)
        case minimumItems(String, Int)
        case invalidValue(String)

        var errorDescription: String? {
            switch self {
            case .templateNotFound:
                "The selected template definition could not be found."
            case .requiredValue(let field):
                "\(field) is required."
            case .minimumItems(let field, let count):
                "\(field) must have at least \(count) item(s)."
            case .invalidValue(let field):
                "\(field) has an invalid value."
            }
        }
    }
}
