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
            System.out.println("attempting");
            res.type("application/json");
            Document userDocument = userCollection.find(and(eq("username", username), eq("password", password))).first();
            if(userDocument != null) {
                System.out.println("LOL");
                Session session = req.session(true);
                return "{\"loggedIn\": true}";
            }
            System.out.println("Couldnt find or wrong username/password");
            return "{\"loggedIn\": false}";
        });


        post("/api/postListing",(req,res)-> {
            System.out.println("Post running");
            System.out.println(req.body());
            //make object to transfer json data!

            return "Post successfully created!";
        });

    }

}