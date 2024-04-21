//
//  FilesController.swift
//
//
//  Created by Ildar Shamsullin on 20.02.2024.
//

import Vapor
import SwiftGD

struct FilesController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws { 
        routes.get("photo", ":filename", use: getPhoto)
    }
    
    func getPhoto(req: Request) async throws -> Response {
        guard let filename = req.parameters.get("filename") else {
            throw Abort(.badRequest)
        }
        
        let workingDirectory = req.application.directory.workingDirectory
        let path = workingDirectory + ServerConfig.photoFolder + filename
        
        return req.fileio.streamFile(at: path)
    }
    
    @discardableResult
    static func saveFilesToDatabase(
        _ filesInfo: [FileInfo],
        message: Message,
        req: Request
    ) async throws -> SavedFiles {
        var savedFiles = SavedFiles()
        
        for fileInfo in filesInfo {
            switch fileInfo.type {
            case .image:
                let image = try Image(data: fileInfo.data)
                
                let photoFile = try PhotoFile(
                    path: fileInfo.path,
                    width: image.size.width,
                    height: image.size.height,
                    fileSize: fileInfo.data.count,
                    message: message)
                try await photoFile.save(on: req.db)
                
                savedFiles.photo.append(photoFile)
            }
        }
        
        return savedFiles
    }
    
    static func writeFilesToDisk(
        _ files: [File],
        req: Request
    ) async throws -> [FileInfo] {
        var filesInfo: [FileInfo] = []
        
        for file in files {
            guard 
                let contentType = file.contentType?.type,
                let fileType = FileType(rawValue: contentType) 
            else {
                throw Abort(.badRequest)
            }
            
            let folder = getFileFolder(for: fileType)
            
            let name = try getFileName(for: file)
            
            let path = folder + name
            
            let workingDirectory = req.application.directory.workingDirectory
            async let _ = try req.fileio.writeFile(file.data, at: workingDirectory + path)
            
            let fileInfo = FileInfo(
                type: fileType, 
                path: path, 
                data: Data(buffer: file.data))
            filesInfo.append(fileInfo)
        }
        
        return filesInfo
    }
    
    static func getFileName(
        for file: File
    ) throws -> String {
        guard let fileExtension = file.extension else {
            throw Abort(.badRequest)
        }
        
        let name = "\(UUID()).\(fileExtension)"
        return name
    }
    
    static func getFileFolder(
        for fileType: FileType
    ) -> String {
        switch fileType {
        case .image:
            return ServerConfig.photoFolder
        }
    }
}

struct FileInfo {
    let type: FileType
    let path: String
    let data: Data
}

struct SavedFiles {
    var photo: [PhotoFile] = []
}
