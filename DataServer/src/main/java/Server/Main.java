import io.javalin.Javalin;
import io.javalin.http.Context;
import io.javalin.websocket.WsContext;
import io.javalin.websocket.WsHandler;
import io.javalin.http.Session;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.google.gson.Gson;
import java.util.Map;
import java.util.function.Consumer;

public class Main {
    public static void main(String[] args) {
        Javalin app = Javalin.create(config -> {
            config.enableCorsForAllOrigins(); // Enable CORS for all origins
        }).start(1235);

        //mongo init
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase db = mongoClient.getDatabase("recipe-app");
        MongoCollection<Document> postCollection = db.getCollection("posts");
        MongoCollection<Document> userCollection = db.getCollection("users");
        MongoCollection<Document> userRequestCollection = db.getCollection("usersRequest");
        MongoCollection<Document> notificationsCollection = db.getCollection("notifications");

        System.out.println("connected to db");

        app.routes(() -> {

            app.ws("/ws", ws -> {
                // define websocket events
            });

            app.before(ctx -> {
                ctx.header("Access-Control-Allow-Origin", "http://localhost:3000");
                ctx.header("Access-Control-Allow-Methods", "GET,POST");
                ctx.header("Access-Control-Allow-Headers", "*");
                ctx.header("Access-Control-Allow-Credentials", "true");
            });

            app.post("/api/register", ctx -> {
                // similar code from SparkJava for this endpoint
            });

            app.post("/api/login", ctx -> {
                // similar code from SparkJava for this endpoint
            });

            app.get("/api/session", ctx -> {
                // similar code from SparkJava for this endpoint
            });

            app.get("/api/notifications/:username", ctx -> {
                // similar code from SparkJava for this endpoint
            });

            app.get("/api/logout", ctx -> {
                // similar code from SparkJava for this endpoint
            });
        });
    }
}
