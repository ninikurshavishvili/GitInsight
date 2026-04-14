# GitInsight

## Description
GitInsight is an entry-level application designed to provide insights into Git repositories, helping users understand their projects better.


## Screenshots
<p>
  <img src="GitInsight/AppScreens/IMG_9312.PNG" width="200" alt="Login Page" style="margin-right:20px;">
    .
  <img src="GitInsight/AppScreens/IMG_9313.PNG" width="200" alt="Github Auth" style="margin-right:20px;">
  <img src="GitInsight/AppScreens/IMG_9314.PNG" width="200" alt="Profile" style="margin-right:10px;">
  <img src="GitInsight/AppScreens/IMG_9315.PNG" width="200" alt="ProfileCards">
</p>


## GitHub Authentication
### 2) Add credentials to `Config.xcconfig`

Create your own `Config.xcconfig` in the project and add:

```xcconfig
GITHUB_CLIENT_ID = your_client_id_here
GITHUB_CLIENT_SECRET = your_client_secret_here
```

Then make sure your target uses this file as its build configuration (Debug/Release as needed).

---


### 3) Keep secrets out of git

- Do **not** commit real credentials.
- Add `Config.xcconfig` to `.gitignore`.
- Commit a safe template file (for example `Config.example.xcconfig`) with placeholder values so others can set up quickly.

Example template:

```xcconfig
GITHUB_CLIENT_ID = YOUR_CLIENT_ID
GITHUB_CLIENT_SECRET = YOUR_CLIENT_SECRET
```

---

### 4) Build and test login

1. Clean and build the app in Xcode.
2. Run the app.
3. Start the login flow.
4. Sign in with GitHub and approve the OAuth app.
5. Confirm you are redirected back to the app and appear as authenticated.




## Getting Started
To run the app:
1. Ensure all dependencies are installed.
2. Use the following commands:


