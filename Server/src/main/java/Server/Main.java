package Server;

import static spark.Spark.*;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.google.gson.Gson;
import java.util.Map;
import spark.Session;

public class Main {
    public static void main(String[] args) {
        port(1235);
        webSocket("/ws",WebSocketHandler.class);


        before((req, res) -> {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET,POST");
            res.header("Access-Control-Allow-Headers", "*");
        });

        //mongo init
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase db = mongoClient.getDatabase("recipe-app");
        MongoCollection<Document> postCollection = db.getCollection("posts");
        MongoCollection<Document> userCollection = db.getCollection("users");

        System.out.println("connected to db");

        /// TODO add authentication to client and this api to avoid waisting computation power
        post("/api/login", (req, res)-> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);
            String username = (String) requestData.get("username");
            String password = (String) requestData.get("password");
            res.type("application/json");
            Document userDocument = userCollection.find(and(eq("username", username), eq("password", password))).first();
            if(userDocument != null) {
                Session session = req.session(true);
                session.attribute("username", username);
                return "{\"loggedIn\": true}";
            }
            System.out.println("Couldnt find or wrong username/password");
            return "{\"loggedIn\": false}";
        });

        get("/api/session", (req, res) -> {
            res.type("application/json");
            Session session = req.session(true);

            if(session.attribute("username") != null) {
                return "{\"loggedIn\": true, \"username\": \"" + session.attribute("username") + "\"}";
            }

            return "{\"loggedIn\": false}";
        });

        get("/api/logout", (req, res)-> {
            Session session = req.session(false);
            if (session != null) {
                session.invalidate();
            }
            return "{\"loggedOut\": true}";
        });


    }

}