package Server;

import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebSocket
public class WebSocketHandler {

  static Map<Session,Session> sessionMap = new ConcurrentHashMap<>();



  @OnWebSocketConnect
  public void connected(Session session) throws IOException {
    System.out.println("A client has connected");
    sessionMap.put(session,session);
    System.out.println("Total connections: "+sessionMap.keySet().size());
  }

  @OnWebSocketClose
  public void closed(Session session, int statusCode, String reason) {
    System.out.println("A client has disconnected");
    sessionMap.remove(session);
    System.out.println("Total connections: "+sessionMap.keySet().size());
  }

  @OnWebSocketMessage
  public void message(Session session, String message) throws IOException {
    System.out.println("Got: " + message);   // Print message
  }
}