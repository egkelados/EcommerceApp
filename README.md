# SmartShop

# Under Development....

## cURL Command

```sh
curl -X <METHOD> <URL> -H "Content-Type: application/json" -d '<JSON_DATA>'
```

## Explanation

| Option                                  | Description                                                                                       |
| --------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **curl**                                | A command-line tool for transferring data to/from a server.                                       |
| **-X <METHOD&gt;**                      | Specifies the HTTP method (e.g., GET, POST, PUT, DELETE) to use.                                  |
| **&lt;URL&gt;**                         | The endpoint where the request is sent. Replace `<URL>` with your API address.                    |
| **-H "Content-Type: application/json"** | Adds a header that tells the server the data is in JSON format.                                   |
| **-d '<JSON_DATA>'**                    | Sends the data (payload) with the request. Replace `<JSON_DATA>` with your JSON-formatted string. |

# [jwt.io](https://jwt.io)

JWT.io is a website that allows you to decode, verify, and generate JSON Web Tokens (JWT). It provides a handy interface to inspect and debug JWTs, making it easier to work with them in your application, extracting the 'exp' property which indicates the expiration time
