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
        MongoCollection<Document> service = db.getCollection("serviceCollection");
        System.out.println("connected to db");

        // Check if service exists
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