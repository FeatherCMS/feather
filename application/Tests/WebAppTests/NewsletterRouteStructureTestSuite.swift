import Foundation
import Testing

@Suite
struct NewsletterRouteStructureTestSuite {
    @Test
    func newsletterRoutesHaveNoDuplicateSignaturesOrRemovePaths() throws {
        let root = URL(filePath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "Sources/WebApp/Features/Admin/Newsletter")
        let files =
            FileManager.default.enumerator(
                at: root,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )?
            .compactMap { $0 as? URL }.filter { $0.pathExtension == "swift" }
            ?? []

        let pattern = #"router\.(get|post|put|delete)\s*\(\s*"([^"]+)""#
        let expression = try NSRegularExpression(pattern: pattern)
        var signatures: [String] = []

        for file in files {
            let source = try String(contentsOf: file, encoding: .utf8)
            let range = NSRange(source.startIndex..<source.endIndex, in: source)
            for match in expression.matches(in: source, range: range) {
                let method = String(
                    source[Range(match.range(at: 1), in: source)!]
                )
                let path = String(
                    source[Range(match.range(at: 2), in: source)!]
                )
                #expect(path.contains("remove") == false)
                signatures.append("\(method.uppercased()) \(path)")
            }
        }

        #expect(Set(signatures).count == signatures.count)
    }
}
