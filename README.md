# FastAPI + MailScout

This project bundles a FastAPI service that:

1. Generates likely email addresses from `first_name`, `last_name`, and `domain` using **MailScout**
2. Returns the first deliverable email or a meaningful error response

## Endpoints

| Method | Path       | Body                                   | Response                        |
|--------|------------|----------------------------------------|---------------------------------|
| GET    | `/health`  | —                                      | `{ "status": "ok" }`            |
| POST   | `/generate`| `{ "first_name": "...", "last_name": "...", "domain": "..." }` | `{ "email": "...", "is_deliverable": true, ... }` |

## Local usage

```bash
docker build -t email-api .
docker run -p 10000:10000 email-api
```

Then:

```bash
curl -X POST http://localhost:10000/generate \
     -H "Content-Type: application/json" \
     -d '{"first_name":"Jane","last_name":"Doe","domain":"example.com"}'
```

## Render deployment

1. Push this repo to GitHub.
2. Create a **Web Service** on Render:
   * Environment: **Docker**
   * Instance: **Free**
   * No build/start commands required
3. Enjoy your free, public API (`https://your-app.onrender.com`).
