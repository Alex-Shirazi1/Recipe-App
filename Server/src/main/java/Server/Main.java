package Server;

import static spark.Spark.*;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Main {
    public static void main(String[] args) {
        port(1235);
        webSocket("/ws",WebSocketHandler.class);

        //mongo init
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase db = mongoClient.getDatabase("posts");
        MongoCollection<Document> myCollection = db.getCollection("data");
        System.out.println("connected to db");

        post("/api/postListing",(req,res)-> {
            System.out.println("Post running");
            System.out.println(req.body());
            //make object to transfer json data!

            return "Post successfully created!";
        });

    }

}