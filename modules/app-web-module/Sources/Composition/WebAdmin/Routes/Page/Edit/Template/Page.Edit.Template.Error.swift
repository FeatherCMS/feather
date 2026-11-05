import Foundation
import WebModule

extension Page.Edit.Template {
    enum Error: LocalizedError {
        case templateNotFound
        case requiredValue(String)
        case invalidValue(String)

        var errorDescription: String? {
            switch self {
            case .templateNotFound:
                "The selected template definition could not be found."
            case .requiredValue(let field):
                "\(field) is required."
            case .invalidValue(let field):
                "\(field) has an invalid value."
            }
        }
    }
}
