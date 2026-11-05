enum MigratorConfigurationError: Error {
    case missing(String)
    case invalidURL(String)
}
