package Server;

import static spark.Spark.*;

import com.mongodb.Mongo;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Indexes;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.google.gson.Gson;

import java.util.*;
import java.util.function.Consumer;

import org.bson.types.ObjectId;
import spark.Session;

import javax.mail.MessagingException;

import com.mongodb.client.gridfs.GridFSBucket;
import com.mongodb.client.gridfs.GridFSBuckets;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.stream.Collectors;
import javax.servlet.MultipartConfigElement;
import javax.servlet.http.Part;
import com.mongodb.client.gridfs.model.GridFSFile;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;

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
        MongoCollection<Document> feedbackCollection = db.getCollection("feedbackCollection");
        MongoCollection<Document> service = db.getCollection("serviceCollection");
        GridFSBucket imageStorage = GridFSBuckets.create(db, "images");

        postCollection.createIndex(Indexes.text("title"));


        System.out.println("connected to db");

        post("/api/createPost", (req, res) -> {
            Session session = req.session(false);
            if (session == null) {
                res.status(401);
                return "User is not logged in";
            }

            String username = session.attribute("username");
            req.attribute("org.eclipse.jetty.multipartConfig", new MultipartConfigElement("/temp"));
            Map<String, String> formFields = new HashMap<>();
            ObjectId fileId = null;

            for (Part part : req.raw().getParts()) {
                String fieldName = part.getName();
                if (part.getSubmittedFileName() != null) {
                    String fileName = part.getSubmittedFileName();
                    InputStream fileContent = part.getInputStream();

                    fileId = imageStorage.uploadFromStream(fileName, fileContent);
                } else {
                    String fieldValue = new BufferedReader(new InputStreamReader(part.getInputStream())).lines().collect(Collectors.joining("\n"));
                    formFields.put(fieldName, fieldValue);
                }
            }

            Document newPost = new Document().append("username", username);
            formFields.forEach(newPost::append);

            if (fileId != null) {
                newPost.append("imageFileId", fileId.toHexString());
            }

            postCollection.insertOne(newPost);

            return "Post created";
        });

        get("/api/posts", (req, res) -> {
            res.type("application/json");
            FindIterable<Document> posts = postCollection.find();
            ArrayList<Document> postsList = new ArrayList<>();
            posts.into(postsList);

            for (Document post : postsList) {
                ObjectId id = post.getObjectId("_id");
                post.put("_id", id.toString());
            }

            return new Gson().toJson(postsList);
        });

        get("/api/search", (req, res) -> {
            res.type("application/json");
            String searchQuery = req.queryParams("query");
            //System.out.println(searchQuery);
            ArrayList<Document> searchResults = new ArrayList<>();
            postCollection.find(Filters.text(searchQuery)).into(searchResults);

            for (Document searchResult: searchResults) {
                ObjectId id = searchResult.getObjectId("_id");
                searchResult.put("_id", id.toString());
            }
            return new Gson().toJson(searchResults);
        });

        get("/api/image/:id", (req, res) -> {
            String id = req.params("id");
            GridFSFile gridFSFile = imageStorage.find(eq("_id", new ObjectId(id))).first();

            if (gridFSFile == null) {
                res.status(404);
                return "File not found";
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            imageStorage.downloadToStream(new ObjectId(id), outputStream);

            HttpServletResponse raw = res.raw();
            raw.getOutputStream().write(outputStream.toByteArray());
            raw.getOutputStream().flush();
            raw.getOutputStream().close();
            return raw;
        });

        delete("/api/deletePost/:id", (req, res) -> {
            Session session = req.session(false);
            if (session == null) {
                res.status(401);
                return "User is not logged in";
            }

            String postId = req.params("id");

            // Fetch the post to get the imageFileId
            Document post = postCollection.find(eq("_id", new ObjectId(postId))).first();

            // If post not found
            if (post == null) {
                res.status(404);
                return "Post not found";
            }
            if (post.get("imageFileId") != null) {
                ObjectId imageFileId = new ObjectId(post.getString("imageFileId"));
                imageStorage.delete(imageFileId);
            }
            postCollection.deleteOne(post);
            return "Post deleted";
        });

        post("/api/register", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);

            String username = requestData.get("username").toString().toLowerCase();
            String email = requestData.get("email").toString().toLowerCase();
            String password = requestData.get("password").toString().toLowerCase();
            Boolean isAdmin = (Boolean) requestData.get("isAdmin");

            // Check if the user already exists
            Document existingUser = userCollection.find(eq("username", username)).first();
            if (existingUser != null) {
                res.status(400);
                return "{\"message\": \"Username already exists\"}";
            }

            // Credentials Validation
            if (username == null || username.isEmpty() || password == null || password.isEmpty() || email == null || email.isEmpty()) {
                res.status(400);
                return "{\"message\": \"Username, email, and password must be provided\"}";
            }
            if(username.length()<4 || username.length() > 20 || password.length()<4) {
                res.status(401);
                return "{\"message\": \"Username and/or password invalid\"}";
            }
            Document registrationRequest = new Document().append("username", username).append("email", email).append("password", password).append("isAdmin", isAdmin).append("approvedState", false);

        if (isAdmin) {
            userRequestCollection.insertOne(registrationRequest);
            // Notify all existing admins about the new potential admin
            FindIterable<Document> allUsers = userCollection.find(and(eq("isAdmin",true), eq("approvedState", true)));
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
            //Email Logic
            try {
                Document credentials = service.find(eq("service", "emailService")).first();
                EmailService emailService = new EmailService(credentials);
                emailService.sendEmail(email,"Pending Approval. ",
                        "Hello " + username +  ",\n\n" +
                                "Your request for creating an account is in review.\n" +
                                "We will notify you when your account state is determined\n" +
                                "\n" +
                                "Sincerely,\n\n" +
                                "The Recipe App Team");
            } catch (MessagingException e) {
                e.printStackTrace();
            }

            res.status(201);
            System.out.println("END");
            return "{\"message\": \"Admin request created successfully and has been send for review\"}";
        }
        registrationRequest.append("approvedState", true);
        userCollection.insertOne(registrationRequest);
         return "{\"message\": \"User created successfully\"}";
        });

        post("/api/login", (req, res) -> {
            Gson gson = new Gson();
            Map<String, Object> requestData = gson.fromJson(req.body(), Map.class);
            String username = requestData.get("username").toString().toLowerCase();
            String password = requestData.get("password").toString().toLowerCase();
            res.type("application/json");
            Document userDocument = userCollection.find(and(eq("username", username), eq("password", password))).first();
            if(userDocument != null) {
                Session session = req.session(true); // If the session doesn't exist, a new one will be created.
                session.attribute("username", username);

                // Token Logic so we can hold integrity of the user logged in with our clients
                String token = UUID.randomUUID().toString();
                session.attribute("token", token);
                return "{\"loggedIn\": true, \"username\": \"" + username + "\", \"token\": \"" + token + "\"}";
            } else {
                Document registrationRequest = userRequestCollection.find(and(eq("username", username), eq("password", password))).first();
                if (registrationRequest != null) {
                    System.out.println("Account Not Approved");
                    return "{\"loggedIn\": false, \"errorMessage\": \"Admin Account not approved\"}";
                }
            }
            System.out.println("Could not find account or wrong username/password");
            return "{\"loggedIn\": false, \"errorMessage\": \"Invalid username or password\"}";
        });


        get("/api/session", (req, res) -> {
            res.type("application/json");
            Session session = req.session(true);

            if(session.attribute("username") != null) {
                return "{\"loggedIn\": true, \"username\": \"" + session.attribute("username") + "\"}";
            }

            return "{\"loggedIn\": false}";
        });

        get("/api/adminNotifications/:username", (req, res) -> {
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

        //FeedBack APIs

        post("/api/sendFeedback", (req, res) -> {
            res.type("application/json");

            FeedbackData data = new Gson().fromJson(req.body(), FeedbackData.class);

            Document feedback = new Document();
            feedback.append("recommend", data.getRecommend());
            feedback.append("comments", data.getComments());

            feedbackCollection.insertOne(feedback);

            res.status(201);
            return "";
        });


        get("/api/getFeedback", (req, res) -> {
                res.type("application/json");
                FindIterable<Document> allFeedback =  feedbackCollection.find();
                ArrayList<Document> feedbackPosts = new ArrayList<>();
                for (Document feedbackPost : allFeedback) {
                    ObjectId id = feedbackPost.getObjectId("_id");
                    feedbackPost.put("_id", id.toString());
                    feedbackPosts.add(feedbackPost);
                }
                return new Gson().toJson(feedbackPosts);
        });

        delete("/api/deleteFeedback/:id", (req, res) -> {
            res.type("application/json");
            String id = req.params(":id");
            Document doc = feedbackCollection.findOneAndDelete(Filters.eq("_id", new ObjectId(id)));
            if (doc != null) {
                return "Feedback deleted";
            } else {
                return "Feedback not deleted";
            }
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
            String email = userRequest.getString("email");
            String requestPassword = userRequest.getString("password");

            Document user = new Document().append("username", requestUsername).append("password", requestPassword).append("approvedState", true);
            userCollection.insertOne(user);
            //Email Logic
            try {
                Document credentials = service.find(eq("service", "emailService")).first();
                EmailService emailService = new EmailService(credentials);
                emailService.sendEmail(email,"Approved 🤙",
                        "Hello " + username +  ",\n\n" +
                                "Congratulations! You have been approved.\n" +
                                "\n" +
                                "Sincerely,\n\n" +
                                "The Recipe App Team");
            } catch (MessagingException e) {
                e.printStackTrace();
            }
            System.out.println("User: " + username + " successfully added to the Server");
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
                String email = userRequest.getString("email");
                //Email Logic
                try {
                    Document credentials = service.find(eq("service", "emailService")).first();
                    EmailService emailService = new EmailService(credentials);
                    emailService.sendEmail(email,"Rejected 😢",
                            "Hello " + username +  ",\n\n" +
                                    "Unfortunately your account could not be approved at this time.\n" +
                                    "We apologize for the inconvenience.\n" +
                                    "\n" +
                                    "Sincerely,\n\n" +
                                    "The Recipe App Team");
                    System.out.println("User: " + username + " successfully declined from the Server");
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            } else {
                res.status(400);
                return "{\"message\": \"No such user request\"}";
            }

            res.status(200);
            return "{\"message\": \"User request deleted successfully\"}";
        });

        delete("/api/adminNotifications/:username", (req, res) -> {
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
        
        //User Validation APIs
        get("/api/emailExists/:email", (req, res) -> {
            String email = req.params(":email").toLowerCase();
            Document userDocument = userCollection.find(eq("email", email)).first();
            boolean result = (userDocument != null);
            return result ? "Email already exists" : "Email does not exist";
        });

        get("/api/usernameExists/:username", (req, res) -> {
            String username = req.params(":username").toLowerCase();
            Document userDocument = userCollection.find(eq("username", username)).first();
            boolean result = (userDocument != null);
            return result ? "Username already exists" : "Username does not exist";
        });

    }
}