import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UsersController())
    try app.register(collection: ThreadsController())
    try app.register(collection: MessagesController())
    try app.register(collection: FilesController())
}
