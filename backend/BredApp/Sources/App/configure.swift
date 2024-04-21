import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    encoder.keyEncodingStrategy = .convertToSnakeCase
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    ContentConfiguration.global.use(encoder: encoder, for: .json)
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUsers())
    app.migrations.add(CreateTokens())
    app.migrations.add(CreateThreads())
    app.migrations.add(CreateMessages())
    app.migrations.add(CreateMessagesRepliesPivot())
    app.migrations.add(CreatePhotoFiles())
    
    try await app.autoMigrate()

    try routes(app)
}
