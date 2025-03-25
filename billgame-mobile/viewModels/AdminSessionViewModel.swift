import SwiftUI
import Foundation


class AdminSessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var selectedSession : Session? = nil
    private let sessionService: SessionService
    
    init(sessionService: SessionService = SessionService()) {
        self.sessionService = sessionService
        updateSessionList()
    }
    
    public func updateSessionList() {
        Task {
            self.sessions = await sessionService.getAllSession()
        }
    }
    
    public func createSession(_ session: Session) {
        sessions.append(session)
        Task {
            await sessionService.createSession(session)
            sleep(1)
            updateSessionList()
        }
    }
    
    public func updateSession (_ session : Session) {
        guard let index :Int = sessions.firstIndex(where: {$0.id == session.id}) else {
            return
        }
        sessions[index] = session
        Task {
            await sessionService.modifySession(session: session)
            sleep(1)
            updateSessionList()
        }
    }
    
    public func editSession (_ session : Session) {
        self.selectedSession = session
    }
    
    public func deleteSession(_ session : Session) {
        sessions.removeAll { $0.id == session.id }
        Task {
            await sessionService.deleteSession(session)
            sleep(1)
            updateSessionList()
        }
    }
}
