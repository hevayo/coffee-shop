import ballerina/http;
import ballerinax/java.jdbc;

type Product record {
    string name;
    decimal price;
    int quantity;
};

jdbc:Client jdbcClient = check new ("jdbc:h2:file:/test.db", "root", "root");

service /counter on new http:Listener(9090) {

    resource function get products() returns Product[]|error {
        Product[] result;
        // Query table with a condition.
        stream<Product, error?> resultStream =
            jdbcClient->query(`SELECT name, price, quantity FROM Product`);

        result = check from var item in resultStream
            select item;

        // Closes the stream to release the resources.
        check resultStream.close();
        // Closes the JDBC client.
        check jdbcClient.close();
        return result;
    }

    resource function post 'order() {

    }
}

