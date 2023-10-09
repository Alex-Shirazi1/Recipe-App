package Server;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.util.Scanner;

public class Setup {
    public static void main(String[] args) {
 
        
        //mongo init
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase db = mongoClient.getDatabase("recipe-app");
        MongoCollection<Document> userCollection = db.getCollection("users");
        MongoCollection<Document> service = db.getCollection("serviceCollection");
        System.out.println("connected to db");


        //first we will start setup with a root user creation
        Document existingRootUser = userCollection.find(new Document("isRoot", true)).first();

        if (existingRootUser == null) {

            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter root username:");
            String rootUsername = scanner.nextLine();

            System.out.println("Enter root password:");
            String rootPassword = scanner.nextLine();


            Document rootUser = new Document()
                    .append("username", rootUsername)
                    .append("password", rootPassword)
                    .append("approvedState", true)
                    .append("isRoot", true);

            userCollection.insertOne(rootUser);

            System.out.println("Root user setup complete.");
        } else {
            System.out.println("Root user already exists.");
        }

        // Check if email service exists
        Document existingService = service.find(new Document("service", "emailService")).first();

        if(existingService == null) {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter the email:");
            String email = scanner.nextLine();

            System.out.println("Enter the password:");
            String password = scanner.nextLine();

            Document serviceDocument = new Document()
                    .append("service", "emailService")
                    .append("email", email)
                    .append("password", password);
            service.insertOne(serviceDocument);
            System.out.println("Email Setup Complete");
            scanner.close();
        } else {
            System.out.println("Email Service already set up");
        }

        System.exit(0);
    }
}