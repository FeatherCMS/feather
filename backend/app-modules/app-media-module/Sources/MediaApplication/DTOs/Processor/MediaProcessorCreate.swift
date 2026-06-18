import Application

public struct MediaProcessorCreate: DTO {
    public let name: String
    public let matchExtensions: String
    public let commandTemplate: String

    public init(name: String, matchExtensions: String, commandTemplate: String)
    {
        self.name = name
        self.matchExtensions = matchExtensions
        self.commandTemplate = commandTemplate
    }
}
