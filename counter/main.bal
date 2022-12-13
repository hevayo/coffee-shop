import ballerina/http;
import ballerinax/java.jdbc;

type Product record {
    string name;
    decimal price;
    int quantity;
};

jdbc:Client jdbcClient = check new ("jdbc:h2:file:/test.db", "root", "root");

service /counter on new http:Listener(9090) {
    @display {
        label: "kitchin",
        id: "kitchin-6e63fd9b-2834-4de1-90e6-2c690cd3b28d"
    }
    http:Client kitchin;

    @display {
        label: "barista",
        id: "barista-491f83cb-350f-40fe-b484-2c0fcf3dcfee"
    }
    http:Client barista;

    @display {
        label: "product",
        id: "product-46562e81-e1a3-41a4-83f6-8462e8cf368c"
    }
    http:Client product;

    function init() returns error? {
        self.kitchin = check new ("");
        self.barista = check new ("");
        self.product = check new ("");
    }

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

