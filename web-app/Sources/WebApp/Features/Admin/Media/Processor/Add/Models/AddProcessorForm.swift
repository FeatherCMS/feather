import Foundation

struct AddProcessorForm: Decodable {
    var fileSuffix: String = ""
    var matchExtensions: String = ""
    var commandTemplate: String = ""
}
