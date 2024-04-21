//
//  ThreadsController.swift
//  
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import Vapor
import Fluent

struct ThreadsController: RouteCollection {

    func boot(routes: Vapor.RoutesBuilder) throws {
        let threadsRoute = routes.grouped("api", "threads")
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        
        let tokenAuthGroup = threadsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenAuthGroup.get(use: getAllHandler)
        tokenAuthGroup.get(":threadID", use: getHandler)
        tokenAuthGroup.on(.POST, "create", body: .collect(maxSize: "50mb"), use: createHandler)
    }
    
    func getAllHandler(req: Request) async throws -> Page<ThreadPreviewObject> {
        let threads = try await Thread.query(on: req.db)
            .sort(\.$id, .descending)
            .with(\.$previewPhoto)
            .with(\.$messages) {
                $0.with(\.$photo)
            }
            .paginate(for: req)
        
        return .init(
            items: try threads.items.map {
                return ThreadPreviewObject(
                    threadId: try $0.requireID(),
                    previewPhoto: $0.previewPhoto?.asPublic(),
                    messagesCount: $0.messages.count,
                    filesCount: $0.messages.reduce(0) { $0 + $1.photo.count },
                    title: $0.title,
                    content: $0.messages.first?.content ?? ""
                )
            },
            metadata: threads.metadata
        )
    }
    
    func getHandler(req: Request) async throws -> Thread.Public {
        guard let threadId = req.parameters.get("threadID", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        guard let thread = try await Thread.query(on: req.db)
            .filter(\.$id == threadId)
            .with(\.$messages, {
                $0.with(\.$repliesTo)
                $0.with(\.$repliesBy)
                $0.with(\.$photo)
                $0.with(\.$user)
            })
            .with(\.$user)
            .first()
        else {
            throw Abort(.notFound)
        }

        return try thread.asPublic()
    }
    
    func createHandler(req: Request) async throws -> ThreadPreviewObject {
        let user = try req.auth.require(User.self)
        
        let createData = try req.content.decode(ThreadCreateRequest.self)
        
        let thread = try Thread(
            title: createData.title,
            user: user)
        try await thread.save(on: req.db)
        
        let message = try Message(
            content: createData.content,
            thread: thread,
            user: user)
        try await message.save(on: req.db)
        
        let files = try await FilesController.writeFilesToDisk(createData.files,
                                                               req: req)
        let savedFiles = try await FilesController.saveFilesToDatabase(files, message: message, req: req)
        
        let firstPhoto = savedFiles.photo.first
        if let firstPhoto {
            try await Thread.setPreviewPhoto(firstPhoto,
                                             thread: thread,
                                             on: req)
        }

        return ThreadPreviewObject(
            threadId: try thread.requireID(),
            previewPhoto: firstPhoto?.asPublic(),
            messagesCount: 1,
            filesCount: savedFiles.photo.count,
            title: thread.title,
            content: message.content)
    }
}

struct ThreadPreviewObject: Content {
    let threadId: Thread.IDValue
    let previewPhoto: PhotoFile.Public?
    let messagesCount: Int
    let filesCount: Int
    let title: String
    let content: String
}
