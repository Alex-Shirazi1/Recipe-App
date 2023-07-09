package Server;

import static spark.Spark.*;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.google.gson.Gson;
import java.util.Map;
import java.util.function.Consumer;
import java.util.Arrays;
import java.util.ArrayList;
import spark.Session;

public class Main {
    public static void main(String[] args) {
        port(1235);
        webSocket("/ws",WebSocketHandler.class);


        before((req, res) -> {
            res.header("Access-Control-Allow-Origin", "http://localhost:3000");
            res.header("Access-Control-Allow-Methods", "GET,POST,DELETE");
            res.header("Access-Control-Allow-Headers", "Content-Type,Authorization");
            res.header("Access-Control-Allow-Credentials", "true");
        });



        //mongo init
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase db = mongoClient.getDatabase("recipe-app");
        MongoCollection<Document> postCollection = db.getCollection("posts");
        MongoCollection<Document> userCollection = db.getCollection("users");
        MongoCollection<Document> userRequestCollection = db.getCollection("usersRequest");
        MongoCollection<Document> notificationsCollection = db.getCollection("notificationsCollection");

        System.out.println("connected to db");

        post("/api/register", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);

            String username = (String) requestData.get("username");
            String password = (String) requestData.get("password");

            // Check if the user already exists
            Document existingUser = userCollection.find(eq("username", username)).first();
            if (existingUser != null) {
                res.status(400);
                return "{\"message\": \"Username already exists\"}";
            }

            // Credentials Validation
            if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
                res.status(400);
                return "{\"message\": \"Username and password must be provided\"}";
            }
            if(username.length()<4 || username.length() > 20 || password.length()<4) {
                res.status(401);
                return "{\"message\": \"Username and/or password invalid\"}";
            }
            Document registrationRequest = new Document().append("username", username).append("password", password).append("approvedState", false);
            userRequestCollection.insertOne(registrationRequest);


            // Notify all existing users about the new user
            FindIterable<Document> allUsers = userCollection.find();
            allUsers.forEach((Consumer<Document>) document -> {
                Document notification = new Document();
                notification.append("username", username);
                notification.append("type", "new registration");
                notification.append("read", false);

                String notifiedUsername = document.getString("username");
                Document notifiedUserNotifications = notificationsCollection.find(eq("username", notifiedUsername)).first();
                if (notifiedUserNotifications == null) {
                    // If there's no document for the user, create a new one
                    notifiedUserNotifications = new Document()
                            .append("username", notifiedUsername)
                            .append("notifications", Arrays.asList(notification))
                            .append("requestedUsername", username);
                    notificationsCollection.insertOne(notifiedUserNotifications);
                } else {
                    // If there's already a document for the user, update it by adding the new notification
                    notificationsCollection.updateOne(eq("username", notifiedUsername), Updates.push("notifications", notification));
                }
            });

            res.status(201);
            return "{\"message\": \"User request created successfully and has been send for review\"}";
        });

        post("/api/login", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);
            String username = (String) requestData.get("username");
            String password = (String) requestData.get("password");
            res.type("application/json");
            Document userDocument = userCollection.find(and(eq("username", username), eq("password", password))).first();
            if(userDocument != null) {
                Session session = req.session(true); // If the session doesn't exist, a new one will be created.
                session.attribute("username", username);
                return "{\"loggedIn\": true, \"username\": \"" + username + "\"}";
            } else {
                Document registrationRequest = userRequestCollection.find(and(eq("username", username), eq("password", password))).first();
                if (registrationRequest != null) {
                    System.out.println("Account Not Approved");
                    return "{\"loggedIn\": false}";
                }
            }
            System.out.println("Could not find account or wrong username/password");
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

        get("/api/notifications/:username", (req, res) -> {
            Session session = req.session(false); // If the session doesn't exist, returns null
            if (session == null) {
                halt(401, "Unauthorized");
            }

            String sessionUsername = session.attribute("username");
            String requestedUsername = req.params(":username");

            // Only proceed to notification logic if we have a valid session with the correct username
            if (sessionUsername == null || !sessionUsername.equals(requestedUsername)) {
                halt(401, "Unauthorized");
            }

            Document userNotificationsDocument = notificationsCollection.find(eq("username", requestedUsername)).first();

            if(userNotificationsDocument == null) {
                return "No notifications for user"; // If no document for user is found, it means user has no notifications.
            }

            res.type("application/json");
            ArrayList notifications = userNotificationsDocument.get("notifications", ArrayList.class);
            return new Gson().toJson(notifications);

        });

        post("/api/user", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);
            String username = (String) requestData.get("username");

            Document userRequest = userRequestCollection.find(eq("username", username)).first();
            if (userRequest != null) {
                userRequestCollection.deleteOne(userRequest);
            } else {
                res.status(400);
                return "{\"message\": \"No such user request\"}";
            }

            String requestUsername = userRequest.getString("username");
            String requestPassword = userRequest.getString("password");

            Document user = new Document().append("username", requestUsername).append("password", requestPassword).append("approvedState", true);
            userCollection.insertOne(user);

            res.status(201);
            return "{\"message\": \"User created successfully\"}";
        });

        post("/api/userDecline", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);
            String username = (String) requestData.get("username");

            Document userRequest = userRequestCollection.find(eq("username", username)).first();
            if (userRequest != null) {
                userRequestCollection.deleteOne(userRequest);
            } else {
                res.status(400);
                return "{\"message\": \"No such user request\"}";
            }

            res.status(200);
            return "{\"message\": \"User request deleted successfully\"}";
        });

        delete("/api/notifications/:username", (req, res) -> {
            String username = req.params("username");
            notificationsCollection.deleteMany(eq("requestedUsername", username));
            res.status(200);
            return "{\"message\": \"Notifications deleted\"}";
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