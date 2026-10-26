import CSS

public struct AdminListTableLayout: Sendable, Equatable {

    public enum Column: Sendable, Equatable {
        case fixed(Int)
        case fraction(Int)
        case actions

        fileprivate var track: String {
            switch self {
            case .fixed(let value):
                "\(value)px"
            case .fraction(let value):
                "minmax(0, \(value)fr)"
            case .actions:
                "160px"
            }
        }
    }

    public let name: String
    public let columns: [Column]
    public let selectionWidth: Int
    public let minimumWidth: Int

    public init(
        name: String,
        columns: [Column],
        selectionWidth: Int = 48,
        minimumWidth: Int = 680
    ) {
        self.name = name
        self.columns = columns
        self.selectionWidth = selectionWidth
        self.minimumWidth = minimumWidth
    }

    var className: String {
        "table-layout-\(name)"
    }

    func gridTemplateColumns(
        hasSelection: Bool
    ) -> String {
        let tracks = (hasSelection ? [.fixed(selectionWidth)] : []) + columns
        return tracks.map(\.track).joined(separator: " ")
    }
}
